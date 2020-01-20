//  
//  DetailSceneCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailSceneCoordinator: BaseSceneCoordinator<UIViewController> {
    
    override func start() -> Observable<UIViewController> {
        let viewModel = DetailSceneViewModel(dependencies: dependencies)
        let viewController = DetailSceneViewController.instantiate(with: viewModel)
        let navigationController = window.rootViewController as? UINavigationController
        navigationController?.pushViewController(viewController, animated: false)
        return Observable.just(viewController)
    }
    
//    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
//        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
//        return coordinate(to: <#Class#>Coordinator)
//    }
}
