//
//  BaseViewModel.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RealmSwift

class BaseViewModel<T> {

    public let dependencies: Dependency
    public var elements: Driver<T>
    public let loadError: Driver<Error>
    public let indicatorViewAnimating: Driver<Bool>
    public let loadAction: Action<T, T>
    
    public let disposeBag = DisposeBag()
    
    init(dependencies: Dependency) {
        self.dependencies = dependencies
        loadAction = Action { .just($0) }
        elements = loadAction.elements.asDriver(onErrorDriveWith: .empty())
        indicatorViewAnimating = loadAction.executing.asDriver(onErrorJustReturn: false)
        loadError = loadAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
    }
}
