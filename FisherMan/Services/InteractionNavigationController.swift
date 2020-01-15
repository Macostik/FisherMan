//
//  InteractionNavigationController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 15.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class InteractionNavigationController: UINavigationController, UINavigationControllerDelegate {
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    private let disposeBag = DisposeBag()
    
    enum PanDirection {
        case left, none, right
    }
    
    public func handleInteraction() {
        var panDirection: PanDirection = .none
        let panGesture = view.rx.panGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .custom { _, otherGestureRecognizer in
                if let scrollView = otherGestureRecognizer.view as? UIScrollView {
                    return scrollView.contentOffset.x == 0
                }
                return true
            }
        })
        panGesture.when(.began).asTranslation()
            .subscribe(onNext: { [weak self, viewControllers] _, velocity in
                panDirection = abs(velocity.x) > abs(velocity.y) ? velocity.x > 0 ? .left : .right : .none
                self?.interactiveTransition = UIPercentDrivenInteractiveTransition()
                self?.delegate = self
                if panDirection == .left {
                    self?.popViewController(animated: true)
                } else if self?.viewControllers.count == 1 {
                    self?.pushViewController(viewControllers.last ?? UIViewController(), animated: true)
                }
            }) .disposed(by: disposeBag)
        panGesture.when(.changed).asTranslation()
            .subscribe(onNext: { [unowned self] translate, _ in
                let percentCompletion = abs(translate.x) > 10 ? abs(translate.x) / self.view.width : 0
                self.interactiveTransition?.update(percentCompletion)
            }) .disposed(by: disposeBag)
        panGesture.when(.ended).asTranslation()
            .subscribe(onNext: {[unowned self] translate, _ in
                let percentCompletion = abs(translate.x) > 10 ? abs(translate.x) / self.view.width : 0
                if (percentCompletion > 0.5) {
                    self.interactiveTransition?.finish()
                } else {
                    self.interactiveTransition?.cancel()
                }
                self.interactiveTransition = nil
            }).disposed(by: disposeBag)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return PopAnimation()
        default:
            return PushAnimation()
        }
    }
    
      func navigationController(_ navigationController: UINavigationController,
                                interactionControllerFor
          animationController: UIViewControllerAnimatedTransitioning)
          -> UIViewControllerInteractiveTransitioning? {
              return interactiveTransition
      }
}
