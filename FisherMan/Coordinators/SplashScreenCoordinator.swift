//  
//  SplashScreenCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift

class SplashScreenCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let dependencies: Dependency
    
    init(window: UIWindow, dependencies: Dependency) {
        self.window = window
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<Void> {
        let viewModel = SplashScreenViewModel(dependencies: dependencies)
        let viewController = SplashScreenViewController.instantiate(with: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.isNavigationBarHidden = true
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return Observable.empty()
    }
}
