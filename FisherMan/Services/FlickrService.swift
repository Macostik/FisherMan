//
//  FlickrService.swift
//  FisherMan
//
//  Created by Yura Granchenko on 30.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation

class FlickrService: RealmService<FavoriteModel> {

    public func getSearchImages(_ searchText: String = "zander fish") {
        APIManager.searchImages(["method": "flickr.photos.search",
                                 "api_key": Constants.flickrKey,
                                 "text": searchText,
                                 "format": "json",
                                 "nojsoncallback": "1"])
            .json()
            .subscribe(onNext: { json in
                let photos = json["photos"]["photo"].arrayValue
                do {
                    let realm = RealmProvider.shared.realm
                    for photo in photos {
                        try realm.write {
                            realm.create(FavoriteModel.self, value: photo.object, update: .modified)
                        }
                    }
                } catch {}
                    
                
            }).disposed(by: disposeBag)
    }
}
