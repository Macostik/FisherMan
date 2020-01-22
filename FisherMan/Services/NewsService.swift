//
//  NewsService.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RealmSwift

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
}
