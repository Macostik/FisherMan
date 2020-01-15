//
//  InteractionAnimation.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import UIKit

class InteractionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let  duration = 0.5
    fileprivate var propertyAnimator: UIViewPropertyAnimator?
    fileprivate let animationParameters = UICubicTimingParameters(animationCurve: .easeInOut)
    fileprivate lazy var animator = {
        UIViewPropertyAnimator(duration: self.duration, timingParameters: self.animationParameters)
    }()
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            return UIViewPropertyAnimator()
    }
}

final class PushAnimation: InteractionAnimation {
    
    override func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            if let propertyAnimator = propertyAnimator { return propertyAnimator }
            guard let toView = transitionContext.view(forKey: .to) else { fatalError() }
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
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

final class PopAnimation: InteractionAnimation {
    
    override func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
        -> UIViewImplicitlyAnimating {
            if let propertyAnimator = propertyAnimator { return propertyAnimator }
            guard let toView = transitionContext.view(forKey: .to),
                let fromView = transitionContext.view(forKey: .from)
                else { fatalError() }
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            let startFrame = fromView.frame
            let endFrame = startFrame.offsetBy(dx: startFrame.width, dy: 0)
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
