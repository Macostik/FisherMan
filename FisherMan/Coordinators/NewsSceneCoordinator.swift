//  
//  NewsSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift

class NewsSceneCoordinator: BaseSceneCoordinator<UINavigationController> {
    
    override func start() -> Observable<UINavigationController> {
        let viewModel = NewsSceneViewModel(dependencies: dependencies)
        let viewController = NewsSceneViewController.instantiate(with: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.isNavigationBarHidden = true
        rootViewController.tabBarItem.title = "title"
        
        return Observable<UINavigationController>.just(rootViewController)
    }
    
    //    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
    //        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
    //        return coordinate(to: <#Class#>Coordinator)
    //    }
}
