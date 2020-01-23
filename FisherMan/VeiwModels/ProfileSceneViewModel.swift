//  
//  ProfileSceneViewModel.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileSceneViewModel: BaseViewModel<ProfileModel> {
    
    public var languageObservable: Observable<Bool>? {
        willSet {
            newValue?.subscribe(onNext: { toggle in
                LanguageManager.shared.locale = toggle ? .ru : .en
            }).disposed(by: disposeBag)
        }
    }
    
}
