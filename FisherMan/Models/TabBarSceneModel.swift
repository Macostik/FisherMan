//  
//  TabBarSceneModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

enum TabBarSceneModel: String, CaseIterable {
    
    case news = "house.fill"
    case search = "magnifyingglass.circle"
    case plus = "plus.circle"
    case heart = "heart.circle"
    case profile = "person.circle"
    
    func coordinator(window: UIWindow, dependencies: Dependency) -> BaseCoordinator<UINavigationController> {
        switch self {
        case .news:
            let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
            coordinator.tabBarIcon = UIImage(systemName: rawValue)
            return coordinator
        case .search:
            let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
            coordinator.tabBarIcon = UIImage(systemName: rawValue)
            return coordinator
        case .plus:
            let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
            coordinator.tabBarIcon = UIImage(systemName: rawValue)
            return coordinator
        case .heart:
            let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
            coordinator.tabBarIcon = UIImage(systemName: rawValue)
            return coordinator
        case .profile:
            let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
            coordinator.tabBarIcon = UIImage(systemName: rawValue)
            return coordinator
        }
    }
}
