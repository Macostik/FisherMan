//  
//  TabBarSceneViewModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class TabBarSceneViewModel: BaseViewModel<Object> {
    
    public var items: Observable<[UINavigationController]>? {
        willSet {
            newValue?.asObservable()
                .subscribe(onNext: { navigationController in
                    navigationController.map({ $0.tabBarItem.image = UIImage(systemName: "home") })
                }).disposed(by: disposeBag)
        }
    }
}
 
