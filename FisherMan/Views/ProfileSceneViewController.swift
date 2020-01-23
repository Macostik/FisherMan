//  
//  ProfileSceneViewController.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileSceneViewController: BaseViewController<ProfileSceneViewModel> {
    
    private let languageSwitch = specify(UISwitch(), {
        $0.isOn = true
    })
    
    override func setupUI() {
        view.backgroundColor = .green
        view.add(languageSwitch, layoutBlock: { $0.top(30).trailing(30) })
    }
    
    override func setupBindings() {
        viewModel!.languageObservable = languageSwitch.rx.isOn.changed.asObservable()
        //        viewModel?.indicatorViewAnimating.drive(<#drive#>),
        //        viewModel?.elements.drive(<#drive#>),
        //        viewModel?.loadError.drive(onNext: {<#drive#>}),
    }
}
