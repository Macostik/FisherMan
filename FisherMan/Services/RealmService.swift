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

protocol RealmServiceType {
    associatedtype T
    func observeEntries<T: Object>() -> Observable<([T], RxRealm.RealmChangeset?)>?
}

public class RealmService<C>: RealmServiceType {
    typealias T = C
    internal let disposeBag = DisposeBag()
    
    public func observeEntries<T: Object>() -> Observable<([T], RxRealm.RealmChangeset?)>? {
        do {
            let realm = try Realm()
            let entries = realm.objects(T.self)
            Logger.info("Entries type of \(type(of: T.self)) (\(entries.count) count) is available")
            return Observable.arrayWithChangeset(from: entries)
        } catch {}
        return Observable.empty()
    }
}
