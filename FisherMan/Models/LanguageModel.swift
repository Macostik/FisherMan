//
//  LanguageModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RealmSwift

final class LanguageModel: Object {
    
    @objc dynamic public var id = 0
    @objc dynamic public var  locale = "en"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
