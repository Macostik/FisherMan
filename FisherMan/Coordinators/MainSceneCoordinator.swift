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
        let mainNavigationController = dependencies.mainNavigationController
        mainNavigationController.viewControllers.append(viewController)
        mainNavigationController.handleInteraction()
        mainNavigationController.isNavigationBarHidden = true
        viewModel.items = Observable.combineLatest(configure())
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
        
        return Observable.empty()
    }
}

extension MainSceneCoordinator {
     public func configure() -> [Observable<UIViewController>] {
           return MainModel.allCases.map {
               switch $0 {
               case .home:
                   let coordinator = TabBarSceneCoordinator(window: window, dependencies: dependencies)
                   return coordinate(to: coordinator)
               case .detail:
                   let coordinator = TabBarSceneCoordinator(window: window, dependencies: dependencies)
                   return coordinate(to: coordinator)
               }
           }
       }
}
