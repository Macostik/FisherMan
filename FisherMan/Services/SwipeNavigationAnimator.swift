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
        return 0.5
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
            
            guard let toViewController = transitionContext.viewController(forKey: .to),
                let toView = transitionContext.view(forKey: .to)
                else { fatalError() }
            let containerView = transitionContext.containerView
            containerView.addSubview(toViewController.view)

            let duration = transitionDuration(using: transitionContext)
            let animationParam = UICubicTimingParameters(animationCurve: .easeInOut)
            let animator = UIViewPropertyAnimator(duration: duration,
                                                  timingParameters: animationParam)
            
            toView.frame = transitionContext.finalFrame(for: toViewController)
            toView.center.x += containerView.width
            
            animator.addAnimations {
                toView.center.x -= containerView.width
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
