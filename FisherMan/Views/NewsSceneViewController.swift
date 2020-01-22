//  
//  NewsSceneViewController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsSceneViewController: BaseViewController<NewsSceneViewModel> {
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func setupUI() {
        view.backgroundColor = .white
        view.add(spinner, layoutBlock: { $0.center() })
    }
    
    override func setupBindings() {
        viewModel?.indicatorViewAnimating.drive(spinner.rx.isAnimating).disposed(by: disposeBag)
//        viewModel?.elements.drive(<#drive#>),
//        viewModel?.loadError.drive(onNext: {<#drive#>}),
    }
}
