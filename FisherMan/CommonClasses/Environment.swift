//
//  Environment.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation

struct Environment {
    
    static let ENV = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String ?? "DEV"
    static var DEV = "DEV"
    static var STG = "STG"
    static var PROD = "PROD"
    
    static let isProduction = ENV == PROD
    static let isDevelop = ENV == DEV
}
