//  
//  TabBarSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarSceneCoordinator: BaseSceneCoordinator<UIViewController> {
    
    override func start() -> Observable<UIViewController> {
        let viewModel = TabBarSceneViewModel(dependencies: dependencies)
        let viewController = TabBarSceneViewController.instantiate(with: viewModel)
        Observable.combineLatest(configure())
            .subscribe(onNext: { viewControllers in
                viewController.viewControllers = viewControllers
            }).disposed(by: disposeBag)
        return Observable.just(viewController)
    }
}

extension TabBarSceneCoordinator {
    public func configure() -> [Observable<UINavigationController>] {
        return TabBarSceneModel.allCases
            .map {  coordinate(to: $0.coordinator(window: window, dependencies: dependencies)) }
    }
}

extension TabBarSceneModel {
    func coordinator(window: UIWindow, dependencies: Dependency) -> BaseCoordinator<UINavigationController> {
           switch self {
           case .news:
               let coordinator = NewsSceneCoordinator(window: window, dependencies: dependencies)
               coordinator.tabBarIcon = UIImage(systemName: rawValue)
               return coordinator
           case .search:
               let coordinator = SearchSceneCoordinator(window: window, dependencies: dependencies)
               coordinator.tabBarIcon = UIImage(systemName: rawValue)
               return coordinator
           case .plus:
               let coordinator = AdditionalSceneCoordinator(window: window, dependencies: dependencies)
               coordinator.tabBarIcon = UIImage(systemName: rawValue)
               return coordinator
           case .heart:
               let coordinator = FavoriteSceneCoordinator(window: window, dependencies: dependencies)
               coordinator.tabBarIcon = UIImage(systemName: rawValue)
               return coordinator
           case .profile:
               let coordinator = ProfileSceneCoordinator(window: window, dependencies: dependencies)
               coordinator.tabBarIcon = UIImage(systemName: rawValue)
               return coordinator
           }
       }
}
