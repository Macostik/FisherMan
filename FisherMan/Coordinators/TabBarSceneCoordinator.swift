//  
//  TabBarSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarSceneCoordinator: BaseSceneCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        let viewModel = TabBarSceneViewModel(dependencies: dependencies)
        let viewController = TabBarSceneViewController.instantiate(with: viewModel)
        let navigationController = window.rootViewController as? UINavigationController
        navigationController?.pushViewController(viewController, animated: false)
        return Observable.just(())
    }
    
//    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
//        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
//        return coordinate(to: <#Class#>Coordinator)
//    }
}

extension TabBarSceneCoordinator {
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
}
