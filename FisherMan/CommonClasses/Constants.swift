//
//  Constants.swift
//  FishWorld
//
//  Created by Yura Granchenko on 14.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import Foundation

//height controls
let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
       .map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
   let navigationBarHeight = 44 + (keyWindow?.safeAreaInsets.bottom ?? 0)
   let tabBarHeight = 44 + (keyWindow?.safeAreaInsets.bottom ?? 0)

struct Constants {
    static let baseURL = Environment.isProduction ? "http://nps-api-proxy.onespace.prod/api/v1/mobile/news" :
        Environment.isDevelop ? "https://nps.simcord.info/api/v1/mobile/news" :
    "http://nps-api-proxy.onespace.stg/api/v1/mobile/news"
    static let groupId = "group.com.GYS.FisherMan"
    
    // Checking
    static let iOS13Version = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 13
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let mainCollectionViewCell     = "mainCollectionViewCell"
    static let serviceID                  = "1fa7ce2d8fde588ac8fc"
    static let localizeNames              = "localizationsShortNames"
}
