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
    fileprivate var interactiveTransition: UIPercentDrivenInteractiveTransition?
    private let items = Observable.just(["one",  "two"])
    
    override func setupUI() {
        view.add(mainCollectionView, layoutBlock: { $0.edges() })
    }
    
    override func setupBindings() {
        items.bind(to: mainCollectionView.rx.items(cellIdentifier: Constants.mainCollectionViewCell,
                                                   cellType: MainCollectionViewCell.self)) { _, data, cell in
                                                    cell.setupEntry(data)
        }.disposed(by: disposeBag)
        let leftSwipeGesture = view.rx.panGesture()
        leftSwipeGesture.when(.began)
            .filter({[unowned self] _ in self.mainCollectionView.contentOffset.x == 0 })
            .subscribe(onNext: { [weak self] _ in
                self?.interactiveTransition = UIPercentDrivenInteractiveTransition()
                self?.navigationController?.delegate = self
                self?.navigationController?.popViewController(animated: true)
            }) .disposed(by: disposeBag)
        leftSwipeGesture.when(.changed).asTranslation()
            .subscribe(onNext: { [unowned self] translate, _ in
                let percentCompletion = translate.x > 10 ? translate.x / self.view.width : 0
                self.interactiveTransition?.update(percentCompletion)
            }) .disposed(by: disposeBag)
        leftSwipeGesture.when(.ended).asTranslation()
            .subscribe(onNext: {[unowned self] translate, _ in
                let percentCompletion = translate.x > 10 ? translate.x / self.view.width : 0
                if (percentCompletion > 0.5) {
                    self.interactiveTransition?.finish()
                } else {
                    self.interactiveTransition?.cancel()
                }
                self.interactiveTransition = nil
            }).disposed(by: disposeBag)
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

extension MainScreenViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimation()
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor
        animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveTransition
    }
}
