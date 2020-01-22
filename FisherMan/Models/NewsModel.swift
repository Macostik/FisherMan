//  
//  NewsModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RealmSwift

final class NewsModel: Object {
    
    @objc dynamic public var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
