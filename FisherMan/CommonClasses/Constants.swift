//
//  Constants.swift
//  FishWorld
//
//  Created by Yura Granchenko on 14.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import Foundation

struct Constants {
    static let baseURL = Environment.isProduction ? "http://nps-api-proxy.onespace.prod/api/v1/mobile/news" :
        Environment.isDevelop ? "http://nps-api-proxy.onespace.devel/api/v1/mobile/news" :
    "http://nps-api-proxy.onespace.stg/api/v1/mobile/news"
    
    static let language                   = "language"
    static let badgeCounter               = "badgeCounter"
    static let toolTip                    = "simcord://tooltip"
    static let shareLink                  = "https://www.bitbon.space/"
    static let supportEmail               = "mobilesupport@bitbon.space"
    static let serviceID                  = "1fa7ce2d8fde588ac8fc"
    static let localizeName               = "localizationShortName"
    static let localizeNames              = "localizationsShortNames"
    static let isActivateNotification     = "isActivateNotification"
    static let locale                     = "locale"
    static let lightPreview               = 1
    static let is_iPad                    = UIDevice.current.userInterfaceIdiom == .pad
    static let screenWidth: CGFloat       = UIScreen.main.bounds.width
    static let screenHeight: CGFloat      = UIScreen.main.bounds.height
    static let splashTimeAnimation        = 3000
    static let showNotificationAlert      = 2000
    static let newCellCardScale: CGFloat  = 0.96
    static let newsCellCard: CGFloat      = UIScreen.main.bounds.width * 1.15
    static let detailsImageHeight:CGFloat = UIScreen.main.bounds.width * 1.3
    static let profileCellHeight: CGFloat = 50.0
    static let searchCellHeight: CGFloat  = 120.0
    static let searchHeightWithDiscription: CGFloat = Constants.searchHeightWithOutDiscription + 47
    static let searchHeightWithOutDiscription: CGFloat = 128
    static let searchBableWidth           = Constants.screenWidth - 80
    static let containerImageWidth        = Constants.screenWidth
    static let containerImageHeight       = Constants.screenWidth * 9/16
    static let screenHeightFor_5_5s_5SE   = UIScreen.main.bounds.height == 568
    static let screenHeightFor_6_6s_7_8   = UIScreen.main.bounds.height == 667
    static let statusBarColor             = UIColor(red: 38/255, green: 20/255, blue: 55/255, alpha: 1.0)
    static let splashTitleColor           = UIColor(red: 81/255, green: 69/255, blue: 85/255, alpha: 1.0)
    static let unselectColor              = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
    static let selectedColor              = UIColor(red: 74/255, green: 106/255, blue: 223/255, alpha: 1.0)
    static let unselectedColor            = UIColor(red: 113/255, green: 149/255, blue: 255/255, alpha: 1.0)
    static let tabbarSelectedColor        = UIColor(red: 74/255, green: 124/255, blue: 223/255, alpha: 1.0)
    static let tabbarUnselectedColor      = UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1.0)
    static let detailNewsColor            = UIColor(red: 86/255, green: 105/255, blue: 219/255, alpha: 1.0)
    static let topBg                      = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let bottomBg                   = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
    
    // Checking
    static let iOS13Version = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 13
}
