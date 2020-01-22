//  
//  ProfileModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RealmSwift

final class ProfileModel: Object {
    
    @objc dynamic public var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
