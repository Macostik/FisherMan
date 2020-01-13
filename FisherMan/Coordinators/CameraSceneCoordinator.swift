//  
//  CameraSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CameraSceneCoordinator: BaseSceneCoordinator<Void> {
    
    private let swipeAnimator = SwipeNavigationAnimator()
    
    override func start() -> Observable<Void> {
        let viewModel = CameraSceneViewModel(dependencies: dependencies)
        let viewController = CameraSceneViewController.instantiate(with: viewModel)
        baseNavigator.viewControllers.append(viewController)
//        baseNavigator.isNavigationBarHidden = true
        baseNavigator.delegate = swipeAnimator
        window.rootViewController = baseNavigator
        window.makeKeyAndVisible()
        
        return Observable.just(())
    }
    
//    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
//        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
//        return coordinate(to: <#Class#>Coordinator)
//    }
}
