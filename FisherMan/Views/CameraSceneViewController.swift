//  
//  CameraSceneViewController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CameraSceneViewController: BaseViewController<CameraSceneViewModel> {

    override func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Center"
        view.add(titleLabel, layoutBlock: { $0.center() })
        view.backgroundColor = .yellow
    }
    
    override func setupBindings() {}
}
