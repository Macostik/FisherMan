//
//  SceneDelegate.swift
//  FisherMan
//
//  Created by Yura Granchenko on 17.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    fileprivate var appCoordinator: AppCoordinator?
    fileprivate let disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let dependencies = Dependency()
            appCoordinator = AppCoordinator(window: window, dependencies: dependencies)
            appCoordinator?.start().subscribe().disposed(by: disposeBag)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
