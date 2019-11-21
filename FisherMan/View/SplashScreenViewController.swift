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
import RxRealm
import RxGesture
import RxAlamofire

class SplashScreenViewController: BaseViewController<SplashScreenViewModel> {
    
    fileprivate let disposeBag = DisposeBag()
    
    private let splashSreen: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "splashScreen")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "FisherMan"
        label.font = .systemFont(ofSize: 50, weight: .black)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupUI() {
        handleView()
    }
    
    override func setupBindings() {
        
    }
    
    
    fileprivate func handleView() {
        view.addSubview(splashSreen)
        view.addSubview(titleTextLabel)
        splashSreen.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashSreen.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        splashSreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        splashSreen.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        titleTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
