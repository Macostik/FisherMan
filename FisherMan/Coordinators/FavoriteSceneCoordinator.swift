//  
//  FavoriteSceneCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteSceneCoordinator: BaseTabBarController<FavoriteSceneViewModel> {
    
    override func controller() -> BaseViewController<FavoriteSceneViewModel> {
        return FavoriteSceneViewController
            .instantiate(with: FavoriteSceneViewModel(dependencies: dependencies))
    }
    //    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
    //        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
    //        return coordinate(to: <#Class#>Coordinator)
    //    }}
}
