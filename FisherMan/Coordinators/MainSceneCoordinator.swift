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

enum SectionTab: String, CaseIterable {
    
    case news = "b"
    case chat = "P"
    case pay = "O"
    
    var name: String {
        switch self {
        case .news: return "tabBar_news"
        case .chat: return "tabBar_chat"
        case .pay: return "tabBar_bonPay"
        }
    }
}

class MainSceneCoordinator: BaseSceneCoordinator<Void> {
    
    override func start() -> Observable<Void> {
        presentCameraScene()
        let viewModel = MainSceneViewModel(dependencies: dependencies)
        let viewController = MainScreenViewController.instantiate(with: viewModel)
        baseNavigator.viewControllers.append(viewController)
        baseNavigator.delegate = viewController
//        baseNavigator.isNavigationBarHidden = true
       
        return Observable.empty()
    }
    
    @discardableResult private func presentCameraScene() -> Observable<Void> {
        let cameraCoordinator = CameraSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: cameraCoordinator)
    }
}
