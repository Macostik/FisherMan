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
    
   fileprivate var propertyAnimator: UIViewPropertyAnimator?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            if let propertyAnimator = propertyAnimator {
                return propertyAnimator
            }
            
            guard let toView = transitionContext.view(forKey: .to),
                let fromView = transitionContext.view(forKey: .from)
                else { fatalError() }
            transitionContext.containerView.insertSubview(toView, aboveSubview: fromView)
            
            let startFrame = toView.transform.translatedBy(x: toView.width, y: 0)
            let endFrame = CGRect(x: 0,
                                  y: 0,
                                  width: toView.width,
                                  height: toView.height)
            
            let duration = transitionDuration(using: transitionContext)
            let animationParam = UICubicTimingParameters(animationCurve: .easeInOut)
            let animator = UIViewPropertyAnimator(duration: 1.0,
                                                  timingParameters: animationParam)
            animator.addAnimations {
                toView.transform = .identity
            }
            animator.addCompletion { (_) in
                if transitionContext.transitionWasCancelled {
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(true)
                }
                self.propertyAnimator = nil
            }
            self.propertyAnimator = animator
            return animator
    }
}

final class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate var propertyAnimator: UIViewPropertyAnimator?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            if let propertyAnimator = propertyAnimator {
                return propertyAnimator
            }
            
            guard let toView = transitionContext.view(forKey: .to),
                let fromView = transitionContext.view(forKey: .from)
                else { fatalError() }
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            
            let startFrame = fromView.frame
            let endFrame = CGRect(x: startFrame.size.width,
                                  y: 0,
                                  width: startFrame.size.width,
                                  height: startFrame.size.height)
            
            let duration = transitionDuration(using: transitionContext)
            let animationParam = UICubicTimingParameters(animationCurve: .easeInOut)
            let animator = UIViewPropertyAnimator(duration: duration,
                                                  timingParameters: animationParam)
            animator.addAnimations {
                fromView.frame = endFrame
            }
            animator.addCompletion { (_) in
                if transitionContext.transitionWasCancelled {
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(true)
                }
                self.propertyAnimator = nil
            }
            self.propertyAnimator = animator
            return animator
    }
}
