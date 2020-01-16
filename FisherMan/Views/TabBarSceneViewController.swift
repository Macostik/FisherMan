//  
//  TabBarSceneViewController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 10.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarSceneViewController<T>: UITabBarController, ViewModelBased, BaseInstance {
    typealias ViewModel = T
    var viewModel: T?
}
