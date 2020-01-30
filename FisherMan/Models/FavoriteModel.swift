//  
//  FavoriteModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RealmSwift

final class FavoriteModel: Object, EntryCollection {
    
    @objc dynamic public var id = ""
    @objc dynamic public var owner = ""
    @objc dynamic public var secret = ""
    @objc dynamic public var server = ""
    @objc dynamic public var farm = 0
    @objc dynamic public var title = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var concatURL: URL? {
        return URL(string: "https://farm" +
            "\(farm)" + ".staticflickr.com/" + server + "/" + id + "_" + secret + ".jpg")
    }
}
