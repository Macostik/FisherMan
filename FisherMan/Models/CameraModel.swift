//  
//  CameraModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RealmSwift

final class CameraModel: Object {
    
    @objc dynamic public var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
