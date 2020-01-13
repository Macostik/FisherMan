//
//  MainSceneViewController.swift
//  FisherMan
//
//  Created by Yura Granchenko on 02.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class MainScreenViewController: BaseViewController<MainSceneViewModel> { 
    
    private let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(MainCollectionViewCell.self,
                                     forCellWithReuseIdentifier: Constants.mainCollectionViewCell)
        return collectionView
    }()
    private let items = Observable.just(["one",  "two"])
    
    override func setupUI() {
        view.add(mainCollectionView, layoutBlock: { $0.edges() })
    }
    
    override func setupBindings() {
        items.bind(to: mainCollectionView.rx.items(cellIdentifier: Constants.mainCollectionViewCell,
                                                   cellType: MainCollectionViewCell.self)) { _, data, cell in
                                                    cell.setupEntry(data)
        }.disposed(by: disposeBag)
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    public func setupEntry(_ entry: String) {
        add(titleLabel, layoutBlock: { $0.edges() })
        titleLabel.text = entry
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor(red: .random(in: 0...1),
                                                     green: .random(in: 0...1),
                                                     blue: .random(in: 0...1),
                                                     alpha: 1.0)
    }
}
