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
        return MainModel.allCases
            .map {  coordinate(to: $0.coordinator(window: window, dependencies: dependencies)) }
    }
}

extension MainModel {
    func coordinator(window: UIWindow, dependencies: Dependency) -> BaseCoordinator<UIViewController> {
        switch self {
        case .main:
            return TabBarSceneCoordinator(window: window, dependencies: dependencies)
        case .detail:
            return DetailSceneCoordinator(window: window, dependencies: dependencies)
        }
    }
}
