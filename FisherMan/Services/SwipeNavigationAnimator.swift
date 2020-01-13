//
//  SwipeNavigationAnimator.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import UIKit

final class SwipeNavigationAnimator: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                                       animationControllerFor operation: UINavigationController.Operation,
                                       from fromVC: UIViewController,
                                       to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return PopAnimation()
        } else {
            return PushAnimation()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor
        animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
             print (">>print 🚒swipe🚒")
        return nil
    }
}

class BaseNavigationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate var toViewController: UIViewController?
    fileprivate var fromViewConroller: UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toViewController = transitionContext.viewController(forKey: .to)
        fromViewConroller = transitionContext.viewController(forKey: .from)
    }
}

final class PushAnimation: BaseNavigationAnimation {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
    }
}

final class PopAnimation: BaseNavigationAnimation {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
    }
}
