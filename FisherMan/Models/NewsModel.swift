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
    
    @objc dynamic public var id = ""
    @objc dynamic public var previewType = 1
    @objc dynamic public var localizationShortName = ""
    @objc dynamic public var previewImageUrl = ""
    @objc dynamic public var previewVideoUrl = ""
    @objc dynamic public var url = ""
    @objc dynamic public var title = ""
    @objc dynamic public var body = ""
    @objc dynamic public var structuredBody = ""
    @objc dynamic public var changeStateDate = ""
    @objc dynamic public var publicationDate = ""
    @objc dynamic public var isDeleted = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
