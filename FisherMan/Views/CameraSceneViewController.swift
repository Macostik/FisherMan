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
    
    fileprivate var interactiveTransition: UIPercentDrivenInteractiveTransition?
    public var mainViewController: MainScreenViewController?
    
    override func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Center"
        view.add(titleLabel, layoutBlock: { $0.center() })
        view.backgroundColor = .yellow
        transitioningDelegate = self
    }
    
    override func setupBindings() {
        let rightSwipeGesture = view.rx.panGesture()
        rightSwipeGesture.when(.began)
            .subscribe(onNext: { [weak self] _ in
                if let mainViewController = self?.mainViewController {
                    self?.interactiveTransition = UIPercentDrivenInteractiveTransition()
//                    self?.transitioningDelegate = self
//                    self?.navigationController?.pushViewController(mainViewController, animated: false)
                }
            }) .disposed(by: disposeBag)
        rightSwipeGesture.when(.changed).asTranslation()
            .subscribe(onNext: { [unowned self] translate, _ in
                let percentCompletion = translate.x < -10 ? abs(translate.x) / self.view.width : 0
                self.interactiveTransition?.update(percentCompletion)
            }) .disposed(by: disposeBag)
        rightSwipeGesture.when(.ended).asTranslation()
            .subscribe(onNext: {[unowned self] translate, _ in
                let percentCompletion =  translate.x < -10 ? abs(translate.x) / self.view.width : 0
                if (percentCompletion > 0.5) {
                    self.interactiveTransition?.finish()
                } else {
                    self.interactiveTransition?.cancel()
                }
                self.interactiveTransition = nil
            }).disposed(by: disposeBag)
    }
}

extension CameraSceneViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushAnimation()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveTransition
    }
}
