//  
//  TabBarModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

enum TabBarModel: String, CaseIterable {
    
    case news = "house.fill"
    case search = "magnifyingglass.circle"
    case plus = "plus.circle"
    case heart = "heart.circle"
    case profile = "person.circle"
}
