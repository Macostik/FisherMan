//  
//  SplashScreenViewModel.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

final class SplashSceneViewModel: BaseViewModel<Object> {
    let animateCompletionObserver = PublishSubject<Void>()
}
