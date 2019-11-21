//  
//  SplashScreenViewController.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SplashScreenViewController: BaseViewController<SplashScreenViewModel> {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func setupUI() {

    }
    
    override func setupBindings() {
//        viewModel?.indicatorViewAnimating.drive
//        viewModel?.elements.drive(<#drive#>),
//        viewModel?.loadError.drive(onNext: {<#drive#>}),
    }
}
