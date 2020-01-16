//
//  MainSceneViewModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class MainSceneViewModel: BaseViewModel<[UIViewController]> {
    
    public var items: Observable<[UIViewController]>? {
        willSet {
            newValue?.asObservable()
                .subscribe(loadAction.inputs)
                .disposed(by: disposeBag)
        }
    }
}
