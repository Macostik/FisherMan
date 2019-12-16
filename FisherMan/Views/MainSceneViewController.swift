//
//  MainSceneViewController.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RealmSwift

class MainScreenViewController: UITabBarController, ViewModelBased, BaseInstance {
    
    typealias ViewModel = MainSceneViewModel
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
