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
    
//    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
//        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
//        return coordinate(to: <#Class#>Coordinator)
//    }
}

extension TabBarSceneCoordinator {
    public func configure() -> [Observable<UINavigationController>] {
        return TabBarSceneModel.allCases
            .map {  coordinate(to: $0.coordinator(window: window, dependencies: dependencies)) }
    }
}
