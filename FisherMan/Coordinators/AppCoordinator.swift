//
//  AppCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    public let dependencies: Dependency
    
    init(window: UIWindow) {
        self.window = window
        self.dependencies = Dependency()
    }
    
    override func start() -> Observable<Void> {
        let splashCoordinator = SplashSceneCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: splashCoordinator)
    }
}
