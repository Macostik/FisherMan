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
    
    @discardableResult private func presentMainScene() -> Observable<Void> {
        let mainCoordinator = MainSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: mainCoordinator)
    }
}
