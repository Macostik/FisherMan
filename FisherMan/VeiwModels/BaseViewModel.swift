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
//    public let elements: Driver<T>
//    public let loadError: Driver<Error>
//    public let indicatorViewAnimating: Driver<Bool>
    
//    fileprivate let loadAction = Action<Void, T>(enabledIf: Observable.just(true),
//                                                  workFactory: { return Observable.empty() })
    public let disposeBag = DisposeBag()
    
    init(dependencies: Dependency) {
        self.dependencies = dependencies
        
//        indicatorViewAnimating = loadAction.executing.asDriver(onErrorJustReturn: false)
//        elements = loadAction.elements.asDriver(onErrorJustReturn: T())
//
//        loadError = loadAction.errors.asDriver(onErrorDriveWith: .empty())
//            .flatMap { error -> Driver<Error> in
//                switch error {
//                case .underlyingError(let error):
//                    return Driver.just(error)
//                case .notEnabled:
//                    return Driver.empty()
//                }
//        }
    }
}
