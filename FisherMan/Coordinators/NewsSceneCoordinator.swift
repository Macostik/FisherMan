//  
//  NewsSceneCoordinator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class NewsSceneCoordinator: BaseTabBarController<NewsSceneViewModel> {
    
    override func controller() -> BaseViewController<NewsSceneViewModel> {
        return NewsSceneViewController.instantiate(with: NewsSceneViewModel(dependencies: dependencies))
    }
    
    //    @discardableResult private func present<#Class#>Scene() -> Observable<Void> {
    //        let <#Class#>Coordinator = <#Class#>SceneCoordinator(window: window, dependencies: dependencies)
    //        return coordinate(to: <#Class#>Coordinator)
    //    }
}
