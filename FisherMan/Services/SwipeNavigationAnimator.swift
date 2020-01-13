//
//  SwipeNavigationAnimator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import UIKit

final class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toView = transitionContext.view(forKey: .to) {
            transitionContext.containerView.add(toView)
            toView.alpha = 0
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1
            }) { _ in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            }
        }
    }
}


final class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
         if let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) {
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromView.x += 100
                fromView.alpha = 0
            }) { _ in
                transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            }
        }
    }
}
