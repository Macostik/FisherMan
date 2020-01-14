//
//  BaseCoordinator.swift
//  FisherMan
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import RxSwift
import Foundation

protocol Navigationable {
    static var navigator: UINavigationController { get }
}

struct MainNavigation: Navigationable {
    static var navigator = UINavigationController()
}

open class BaseCoordinator<ResultType> {
    
    typealias CoordinationResult = ResultType
    
    public let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    var mainNavigation = MainNavigation.navigator
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    public func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    public func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

open class BaseSceneCoordinator<T>: BaseCoordinator<T> {
    
    internal let window: UIWindow
    internal let dependencies: Dependency
    
    init(window: UIWindow, dependencies: Dependency) {
        self.window = window
        self.dependencies = dependencies
    }
}
