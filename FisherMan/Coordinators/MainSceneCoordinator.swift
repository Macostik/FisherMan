//  
//  MainSceneCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift

class MainSceneCoordinator: BaseCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        let viewModel = MainSceneViewModel(dependencies: dependencies)
        let viewController = MainSceneViewController.instantiate(with: viewModel)
        let navigationController = window.rootViewController as? UINavigationController
        navigationController?.pushViewController(viewController, animated: false)
        return Observable.just(())
    }
    
    @discardableResult private func present<#Class#>Screen(presentingViewController: NewsViewController,
                                                        newsModel: NewsModel?,
                                                        isAnimate: Bool) -> Observable<Void> {
    let <#class#>Coordinator = <#Class#>Coordinator(window: window,
                                                  dependencies: dependencies)
        return coordinate(to: detailCoordinator)
    }
}

