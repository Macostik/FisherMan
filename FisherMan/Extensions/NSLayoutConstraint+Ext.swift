//
//  NSLayoutConstraint+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 17.11.2019.
//  Copyright © 2019 GYS. All rights reserved.

import Foundation
import UIKit

protocol NSLayoutContraintPresentable {
    func layout(_ view: UIView) -> [NSLayoutConstraint?]
}

enum LayoutPositionable: NSLayoutContraintPresentable {
    case center(UIView?)
    case top(CGFloat, UIView?)
    case edges(CGFloat, UIView?)
    case bottom(CGFloat, UIView?)
    case centerX(CGFloat, UIView?)
    case centerY(CGFloat, UIView?)
    case leading(CGFloat, UIView?)
    case trailing(CGFloat, UIView?)
    case topBottom(CGFloat, UIView?)
    case bottomTop(CGFloat, UIView?)
    case topCenterY(CGFloat, UIView?)
    case centerYTop(CGFloat, UIView?)
    case aspectRatio(CGFloat, UIView?)
    case size(CGFloat, UIView?, CGFloat)
    case centerYBottom(CGFloat, UIView?)
    case bottomCenterY(CGFloat, UIView?)
    case centerXLeading(CGFloat, UIView?)
    case leadingCenterX(CGFloat, UIView?)
    case width(CGFloat, UIView?, CGFloat)
    case leadingTrailing(CGFloat, UIView?)
    case trailingLeading(CGFloat, UIView?)
    case trailingCenterX(CGFloat, UIView?)
    case centerXTrailing(CGFloat, UIView?)
    case height(CGFloat, UIView?, CGFloat)
}

extension NSLayoutContraintPresentable where Self == LayoutPositionable {
    
    func layout(_ view: UIView) -> [NSLayoutConstraint?] {
        switch self {
        case .aspectRatio(let constant, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.heightAnchor.constraint(equalTo: (toView ?? superView).widthAnchor,
                                                 multiplier: constant)]
        case .centerYBottom(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerYAnchor.constraint(equalTo: (toView ?? superView).bottomAnchor,
                                                  constant: inset)]
        case .bottomCenterY(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.bottomAnchor.constraint(equalTo: (toView ?? superView).centerYAnchor,
                                                 constant: inset)]
        case .bottom(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.bottomAnchor.constraint(equalTo: (toView ?? superView).bottomAnchor,
                                                 constant: -inset)]
        case .leading(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.leadingAnchor.constraint(equalTo: (toView ?? superView).leadingAnchor,
                                                  constant: inset)]
        case .centerX(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerXAnchor.constraint(equalTo: (toView ?? superView).centerXAnchor,
                                                  constant: inset)]
        case .centerY(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerYAnchor.constraint(equalTo: (toView ?? superView).centerYAnchor,
                                                  constant: inset)]
        case .leadingCenterX(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.leadingAnchor.constraint(equalTo: (toView ?? superView).centerXAnchor,
                                                  constant: inset)]
        case .centerXLeading(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerXAnchor.constraint(equalTo: (toView ?? superView).leadingAnchor,
                                                  constant: inset)]
        case .centerXTrailing(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerXAnchor.constraint(equalTo: (toView ?? superView).trailingAnchor,
                                                  constant: inset)]
        case .leadingTrailing(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.leadingAnchor.constraint(equalTo: (toView ?? superView).trailingAnchor,
                                                  constant: inset)]
        case .trailingLeading(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.trailingAnchor.constraint(equalTo: (toView ?? superView).leadingAnchor,
                                                   constant: inset)]
        case .trailingCenterX(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.trailingAnchor.constraint(equalTo: (toView ?? superView).centerXAnchor,
                                                   constant: inset)]
        case .trailing(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.trailingAnchor.constraint(equalTo: (toView ?? superView).trailingAnchor,
                                                   constant: -inset)]
        case .edges(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.leadingAnchor.constraint(equalTo: (toView ?? superView).leadingAnchor,
                                                  constant: inset),
                    view.topAnchor.constraint(equalTo: (toView ?? superView).topAnchor,
                                              constant: inset),
                    view.bottomAnchor.constraint(equalTo: (toView ?? superView).bottomAnchor,
                                                 constant: -inset),
                    view.trailingAnchor.constraint(equalTo: (toView ?? superView).trailingAnchor,
                                                   constant: -inset)]
        case .center(let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerXAnchor.constraint(equalTo: (toView ?? superView).centerXAnchor),
                    view.centerYAnchor.constraint(equalTo: (toView ?? superView).centerYAnchor)]
        case .width(let constant, let equalView, let multiplier):
            guard let equalView = equalView else {
                return [view.widthAnchor.constraint(equalToConstant: constant)]
            }
            return [view.widthAnchor.constraint(equalTo: equalView.widthAnchor, multiplier: multiplier)]
        case .size(let constant, let equalView, let multiplier):
            guard let equalView = equalView else {
                return [view.widthAnchor.constraint(equalToConstant: constant),
                        view.heightAnchor.constraint(equalToConstant: constant)]
            }
            return [view.widthAnchor.constraint(equalTo: equalView.widthAnchor, multiplier: multiplier),
                    view.heightAnchor.constraint(equalTo: equalView.heightAnchor, multiplier: multiplier)]
        case .height(let constant, let equalView, let multiplier):
            guard let equalView = equalView else {
                return [view.heightAnchor.constraint(equalToConstant: constant)]
            }
            return [view.heightAnchor.constraint(equalTo: equalView.heightAnchor, multiplier: multiplier)]
        case .top(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.topAnchor.constraint(equalTo: (toView ?? superView).topAnchor, constant: inset)]
        case .topBottom(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.topAnchor.constraint(equalTo: (toView ?? superView).bottomAnchor, constant: inset)]
        case .bottomTop(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.bottomAnchor.constraint(equalTo: (toView ?? superView).topAnchor, constant: inset)]
        case .centerYTop(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.centerYAnchor.constraint(equalTo: (toView ?? superView).topAnchor, constant: inset)]
        case .topCenterY(let inset, let toView):
            guard let superView = view.superview else { return [nil] }
            return [view.topAnchor.constraint(equalTo: (toView ?? superView).centerYAnchor, constant: inset)]
        }
    }
}

extension Array where Element == LayoutPositionable {
    
    func helper(params: (LayoutPositionable)) -> [Element] {
        var _self = self
        _self.append(params)
        return _self
    }

    func size(_ size: CGFloat = 0.0,
              to view: UIView? = nil,
              with multiplier: CGFloat = 1) -> [Element] {
        return helper(params: .size(size, view, multiplier))
    }
    
    func width(_ constant: CGFloat = 0.0,
               to view: UIView? = nil,
               with multiplier: CGFloat = 1) -> [Element] {
        return helper(params: .width(constant, view, multiplier))
    }
    
    func height(_ constant: CGFloat = 0.0,
                to view: UIView? = nil,
                with multiplier: CGFloat = 1) -> [Element] {
        return helper(params: .height(constant, view, multiplier))
    }
    
    func center(_ view: UIView? = nil) -> [Element] {
        return helper(params: .center(view))
    }
    
    func top(_ offset: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .top(offset, view))
    }
    
    func edges(_ offset: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .edges(offset, view))
    }
    
    func bottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .bottom(constant, view))
    }
    
    func centerX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerX(constant, view))
    }
    
    func centerY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerY(constant, view))
    }
    
    func leading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .leading(constant, view))
    }
    
    func trailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .trailing(constant, view))
    }
    
    func topBottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .topBottom(constant, view))
    }
    
    func bottomTop(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .bottomTop(constant, view))
    }
    
    func topCenterY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .topCenterY(constant, view))
    }
    
    func centerYTop(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerYTop(constant, view))
    }
    
    func aspectRatio(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .aspectRatio(constant, view))
    }
    
    func centerYBottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerYBottom(constant, view))
    }
    
    func bottomCenterY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .bottomCenterY(constant, view))
    }
    
    func centerXLeading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerXLeading(constant, view))
    }
    
    func leadingCenterX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .leadingCenterX(constant, view))
    }
    
    func leadingTrailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .leadingTrailing(constant, view))
    }
    
    func trailingLeading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .trailingLeading(constant, view))
    }
    
    func trailingCenterX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .trailingCenterX(constant, view))
    }
    
    func centerXTrailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [Element] {
        return helper(params: .centerXTrailing(constant, view))
    }
}

extension UIView {
    
    func add<T>(_ subView: T, layoutBlock: ((T) -> [LayoutPositionable])) where T: UIView {
        add(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        layoutBlock(subView).forEach({ NSLayoutConstraint.activate($0.layout(subView).compactMap({$0})) })
    }
    
    func bringSubviewToFront<T>(_ subView: T, layoutBlock: ((T) -> [LayoutPositionable])) where T: UIView {
        add(subView, layoutBlock: layoutBlock)
        bringSubviewToFront(subView)
    }
    
    func sendSubviewToBack<T>(_ subView: T, layoutBlock: ((T) -> [LayoutPositionable])) where T: UIView {
        add(subView, layoutBlock: layoutBlock)
        sendSubviewToBack(subView)
    }
    
    func width(_ constant: CGFloat = 0.0,
               to view: UIView? = nil,
               with multiplier: CGFloat = 1) -> [LayoutPositionable] {
        return [.width(constant, view, multiplier)]
    }
    
    func top(_ offset: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.top(offset, view)]
    }
    
    func edges(_ offset: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.edges(offset, view)]
    }

    func bottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.bottom(constant, view)]
    }
    
    func height(_ constant: CGFloat = 0.0,
                to view: UIView? = nil,
                with multiplier: CGFloat = 1) -> [LayoutPositionable] {
        return [.height(constant, view, multiplier)]
    }
    
    func center(_ view: UIView? = nil) -> [LayoutPositionable] { return [.center(view)] }

    func centerX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerX(constant, view)]
    }
    
    func centerY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerY(constant, view)]
    }
    
    func leading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.leading(constant, view)]
    }
    
    func trailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.trailing(constant, view)]
    }
    
    func topBottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.topBottom(constant, view)]
    }
    
    func bottomTop(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.bottomTop(constant, view)]
    }
    
    func topCenterY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.topCenterY(constant, view)]
    }
    
    func centerYTop(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerYTop(constant, view)]
    }
    
    func aspectRatio(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.aspectRatio(constant, view)]
    }
    
    func centerYBottom(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerYBottom(constant, view)]
    }
    
    func bottomCenterY(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.bottomCenterY(constant, view)]
    }
    
    func centerXLeading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerXLeading(constant, view)]
    }
    
    func leadingCenterX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.leadingCenterX(constant, view)]
    }
    
    func leadingTrailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.leadingTrailing(constant, view)]
    }
    
    func trailingLeading(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.trailingLeading(constant, view)]
    }
    
    func trailingCenterX(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.trailingCenterX(constant, view)]
    }
    
    func centerXTrailing(_ constant: CGFloat = 0.0, to view: UIView? = nil) -> [LayoutPositionable] {
        return [.centerXTrailing(constant, view)]
    }
    
    func size(_ size: CGFloat = 0.0, to view: UIView? = nil,
              with multiplier: CGFloat = 1) -> [LayoutPositionable] {
        return [.size(size, view, multiplier)]
    }
}
