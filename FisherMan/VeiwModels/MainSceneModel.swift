//  
//  MainSceneModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RealmSwift

final class MainSceneModel: Object {

    @objc dynamic public var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
