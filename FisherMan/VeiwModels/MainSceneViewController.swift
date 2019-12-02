//  
//  MainSceneViewController.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainSceneViewController: BaseViewController, StoryboardBased, ViewModelBased {
    
    typealias ViewModel = MainSceneViewModel
    var viewModel: ViewModel?
    fileprivate let disposeBag = DisposeBag()
    
    override func setupUI() {
       
    }
    
    override func setupBindings() {
//        viewModel?.indicatorViewAnimating.drive(<#drive#>),
//        viewModel?.elements.drive(<#drive#>),
//        viewModel?.loadError.drive(onNext: {<#drive#>}),
    }
}
