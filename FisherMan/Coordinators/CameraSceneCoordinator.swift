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
    
    override func start() -> Observable<Void> {
        let viewModel = CameraSceneViewModel(dependencies: dependencies)
        let viewController = CameraSceneViewController.instantiate(with: viewModel)
        dependencies.mainNavigationController.viewControllers.append(viewController)
        presentMainScene()
        return Observable.just(())
    }
    
    @discardableResult private func presentMainScene() -> Observable<Void> {
        let mainCoordinator = MainSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: mainCoordinator)
    }
}
