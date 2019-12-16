//
//  MainSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum SectionTab: String, CaseIterable {
    
    case news = "b"
    case chat = "P"
    case pay = "O"
    
    var name: String {
        switch self {
        case .news: return "tabBar_news"
        case .chat: return "tabBar_chat"
        case .pay: return "tabBar_bonPay"
        }
    }
}

class MainSceneCoordinator: BaseSceneCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        let viewModel = MainSceneViewModel(dependencies: dependencies)
        let viewController = MainScreenViewController.instantiate(with: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.isNavigationBarHidden = true
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return Observable.empty()
    }
    
    public func configure() -> [Observable<UINavigationController>] {
            return SectionTab.allCases.map {
                switch $0 {
                case .news:
                    let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
                    return coordinate(to: coordinator)
    //            case .myActives:
    //                let coordinator = ActivitesCoordinator(window: window, dependencies: dependencies)
    //                return coordinate(to: coordinator)
//                case .chat:
//                    let coorfinator = ChatCoordinator(window: window, dependencies: dependencies)
//                    return coordinate(to: coorfinator)
//                case .pay:
//                    let coordinator = PayCoordinator(window: window, dependencies: dependencies)
//                    return coordinate(to: coordinator)
                default:
                    let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
                    return coordinate(to: coordinator)
                    break
                }
            }
        }
    }
    
//      let  viewControllers = [
//            createNavController(viewController: MusicController(), title: "Music", imageName: "music"),
//            createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
//            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
//            createNavController(viewController: AppSearchController(), title: "Search", imageName: "search"),
//        ]

    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = #imageLiteral(resourceName: "splashAvatar")
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        return navController
    }
    
    @discardableResult private func presentMainScene() -> Observable<Void> {
        let mainCoordinator = MainSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: mainCoordinator)
    }
}
