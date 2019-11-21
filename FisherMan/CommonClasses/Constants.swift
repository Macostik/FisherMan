//
//  Constants.swift
//  FishWorld
//
//  Created by Yura Granchenko on 14.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation

struct Constants {
    static let baseURL = Environment.isProduction ? "http://nps-api-proxy.onespace.prod/api/v1/mobile/news" :
        Environment.isDevelop ? "http://nps-api-proxy.onespace.devel/api/v1/mobile/news" :
    "http://nps-api-proxy.onespace.stg/api/v1/mobile/news"
}
