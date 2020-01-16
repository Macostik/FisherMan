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
import RxGesture

class MainScreenViewController: BaseViewController<MainSceneViewModel> { 
    
    private let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(MainCollectionViewCell.self,
                                     forCellWithReuseIdentifier: Constants.mainCollectionViewCell)
        return collectionView
    }()
    
    override func setupUI() {
        view.add(mainCollectionView, layoutBlock: { $0.edges() })
    }
    
    override func setupBindings() {
        viewModel?.items?.asObservable()
//        .subscribe(onNext: { vcs in
//            print (">>print 🚒\(vcs)🚒")
//            }).disposed(by: disposeBag)
            .bind(to: mainCollectionView.rx.items(cellIdentifier: Constants.mainCollectionViewCell,
                                                  cellType: MainCollectionViewCell.self)) { _, data, cell in
                                                    cell.setupEntry(data)
        }.disposed(by: disposeBag)
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    
    public func setupEntry(_ entry: UIViewController) {
        add(entry.view, layoutBlock: { $0.edges() })
    }
}
