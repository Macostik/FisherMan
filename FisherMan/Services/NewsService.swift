//
//  NewsService.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

enum EmptyError: Error {
    case empty
}

class NewsService: RealmService<NewsModel> {
    
    public func getAllNews(completion: (() -> Void)? = nil) {
        var newsList = [NewsModel]()
        APIManager.allNews(["serviceId": Constants.serviceID,
                            "localizationsShortNames": [Localable.ru.rawValue, Localable.en.rawValue]])
        .json().subscribe(onNext: { json in
            do {
                let realm = RealmProvider.shared.realm
                try realm.write {
                    let data = json["items"]
                    if !data.isEmpty {
                        for entity in data.arrayValue {
                            let object = realm.create(T.self, value: entity.object, update: .modified)
                            newsList.append(object)
                        }
                        Logger.info("Initiate news were loaded - \(data.count)")
                    }
                }
                completion?()
            } catch let error {
                Logger.error("DataBase of Realm was changed \(error)")
                completion?()
            }
        }, onError: { _ in
            completion?()
        }).disposed(by: disposeBag)
    }
    
    @discardableResult public func getOldNews() -> Completable? {
        return Completable.create { [unowned self] completable in
            if let minPublishData = T.minPublishDate() {
                APIManager.oldNews(["serviceId": Constants.serviceID,
                                    "publicationDate": minPublishData,
                                    Constants.localizeName: LanguageManager.shared.locale.rawValue])
                    .json().subscribe(onNext: { json in
                        do {
                            let realm = try Realm()
                            try realm.write {
                                let data = json["items"]
                                if !data.isEmpty {
                                    for entity in data.arrayValue {
                                        realm.create(T.self, value: entity.object, update: .modified)
                                    }
                                    Logger.info("Old news were loaded - \(data.count)")
                                    completable(.completed)
                                } else {
                                    completable(.error(EmptyError.empty))
                                }
                            }
                        } catch {}
                    }, onError: { error in
                        completable(.error(error))
                    }).disposed(by: self.disposeBag)
            }
            return Disposables.create {}
        }
    }
}
