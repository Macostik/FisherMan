//
//  RealmService.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift

typealias RealmObservable<T> = ([T], RxRealm.RealmChangeset?)

protocol BaseNewsModelType: EntryCollection {
    var id: String { get }
    var publicationDate: String { get }
    var localizationShortName: String { get }
    static func minPublishDate() -> String?
    static func lastChangeStateID() -> String?
}

protocol RealmServiceType {
    associatedtype T
    func observeEntries<T: Object>() -> Observable<(RealmObservable<T>)>?
}

public class RealmService<T>: RealmServiceType {
    internal let disposeBag = DisposeBag()
    
    func observeEntries<T: Object>() -> Observable<(RealmObservable<T>)>? {
        let realm = RealmProvider.shared.realm
        let entries = realm.objects(T.self)
        Logger.info("Entries type of \(type(of: T.self)) (\(entries.count) count) is available")
        return Observable.arrayWithChangeset(from: entries)
    }
}

struct RealmProvider {
  private let configuration: Realm.Configuration

  internal init(config: Realm.Configuration) { configuration = config }
    
  public var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            Logger.error("Realm was not configured!")
            fatalError()
        }
    }
    
    private static func configureRealm() -> Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        var groupURL = config.fileURL?
            .deletingLastPathComponent().appendingPathComponent("\(Environment.ENV).realm")
        do {
            groupURL = try Path.inSharedContainer("\(Environment.ENV).realm")
        } catch {
            Logger.error("Group path for Realm is absent")
        }
        let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL
        if realmFileURL?.absoluteString != groupURL?.absoluteString {
            config.fileURL = groupURL
            config.schemaVersion = 1
            config.migrationBlock = { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) { }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        if let realmFileURL = config.fileURL {
            Logger.info("\(realmFileURL)")
        }
        return config
    }
    
    public static var shared = RealmProvider(config: configureRealm())
}

protocol EntryCollection {
    static func entries() -> [Self]
}

extension EntryCollection where Self: Object {
    static func entries() -> [Self] {
        let realm = RealmProvider.shared.realm
        return Array(realm.objects(self))
    }
}

extension Realm {
    func arrayWithChangeset<T: Object>() -> Observable<([T], RxRealm.RealmChangeset?)>? {
        let entries = self.objects(T.self)
        Logger.verbose("Entries type of \(type(of: T.self)) (\(entries.count) count) is available")
        return Observable.arrayWithChangeset(from: entries)
    }
    
    func writeAsync<T: ThreadConfined>(obj: T,
                                       failBlock: @escaping ((_ error: Swift.Error) -> Void) = {_ in return },
                                       successBlock: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let provider = RealmProvider.shared
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = provider.realm
                    let obj = realm.resolve(wrappedObj)
                    try realm.write {
                        successBlock(realm, obj)
                    }
                } catch {
                    failBlock(error)
                }
            }
        }
    }
}

extension BaseNewsModelType where Self: Object {
    static func minPublishDate() -> String? {
        let realm = RealmProvider.shared.realm
        let articles = realm.objects(self)
        let locale = realm.objects(LanguageModel.self).first?.locale
        return articles.filter({ $0.localizationShortName == locale })
            .map({ Int($0.publicationDate) ?? 0 }).min()?.toString()
    }
    
    static func lastChangeStateID() -> String? {
        let realm = RealmProvider.shared.realm
        let articles = realm.objects(self)
        let locale = realm.objects(LanguageModel.self).first?.locale
        return articles.filter({ $0.localizationShortName == locale })
            .sorted(by: { Int($0.publicationDate) ?? 0 > Int($1.publicationDate) ?? 0 }).first?.id ?? ""
    }
}
