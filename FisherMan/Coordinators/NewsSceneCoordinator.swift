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
    
    public var tabBarIcon: UIImage?
    
    override func start() -> Observable<UINavigationController> {
        let viewModel = NewsSceneViewModel(dependencies: dependencies)
        let viewController = NewsSceneViewController.instantiate(with: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.tabBarItem.image = tabBarIcon
        
        return Observable<UINavigationController>.just(navigationController)
    }
    
    //    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
    //        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
    //        return coordinate(to: <#Class#>Coordinator)
    //    }
}
