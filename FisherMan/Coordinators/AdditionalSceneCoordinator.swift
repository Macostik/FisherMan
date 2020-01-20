//  
//  AdditionalSceneCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AdditionalSceneCoordinator: BaseSceneCoordinator<UINavigationController> {
    
    public var tabBarIcon: UIImage?
    
    override func start() -> Observable<UINavigationController> {
        let viewModel = AdditionalSceneViewModel(dependencies: dependencies)
        let viewController = AdditionalSceneViewController.instantiate(with: viewModel)
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
