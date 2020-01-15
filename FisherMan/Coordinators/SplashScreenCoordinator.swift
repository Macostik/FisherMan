//  
//  SplashScreenCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift

class SplashSceneCoordinator: BaseSceneCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        let viewModel = SplashSceneViewModel(dependencies: dependencies)
        let viewController = SplashScreenViewController.instantiate(with: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController.isNavigationBarHidden = true
        viewModel.animateCompletionObserver.subscribe(onNext: { [weak self] _ in
            self?.presentCameraScene()
        }).disposed(by: disposeBag)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return Observable.empty()
    }
    
    @discardableResult private func presentCameraScene() -> Observable<Void> {
        let cameraCoordinator = CameraSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: cameraCoordinator)
    }
}
