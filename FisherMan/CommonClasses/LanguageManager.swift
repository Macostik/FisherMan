//
//  LanguageManager.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

enum Localable: String {
    case en, ru
}

final class LanguageManager {
    
    static let shared = LanguageManager()
    fileprivate let disposeBag = DisposeBag()
    public let notifyObservable = BehaviorSubject<Void>(value: ())
    
    init() {
        do {
            let realm = try Realm()
            guard let language = realm.objects(LanguageModel.self).first else {
                let deviceLocale = Locale.preferredLanguages[0].prefix(2).toString()
                let language = LanguageModel()
                language.locale = deviceLocale
                locale = Localable(rawValue: deviceLocale) ?? .en
                try realm.write {
                    realm.add(language, update: .modified)
                }
                return
            }
            locale = Localable(rawValue: language.locale) ?? .en
        } catch {}
    }
    
    public var bundle: Bundle {
        return Bundle(path: Bundle.main.path(forResource: locale.rawValue, ofType: "lproj") ?? "")
            ?? Bundle.main
    }
    
    public var locale: Localable = .en {
        didSet {
            Logger.verbose("Set new locale: \(locale.rawValue)")
            do {
                let realm = try Realm()
                let language = LanguageModel()
                language.locale = locale.rawValue
                try realm.write {
                    realm.add(language, update: .modified)
                }
                notifyObservable.onNext(())
            } catch {}
        }
    }
    
    public var language: String {
        let language = locale == .en ? "English" : "Russian"
        return language
    }
    
    public var isRussian: Bool {
        return locale == .ru
    }
}
