//
//  UIView+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit

public func specify<T>(_ object: T, _ specify: (T) -> Void) -> T {
    specify(object)
    return object
}

extension UIView {
    
    public var x: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }
    
    public var y: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }
    
    public var width: CGFloat {
        set { frame.size.width = newValue }
        get { return frame.size.width }
    }
    
    public var height: CGFloat {
        set { frame.size.height = newValue }
        get { return frame.size.height }
    }
    
    public var size: CGSize {
        set { frame.size = newValue }
        get { return frame.size }
    }
    
    public var centerBoundary: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    @discardableResult public func add<T: UIView>(_ subview: T) -> T {
        addSubview(subview)
        return subview
    }
    
    public func forceLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Regular Animation
    
    class func performAnimated( animated: Bool, animation: @escaping () -> Void) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: animation)
        }
    }
    
    public func setAlpha(alpha: CGFloat, animated: Bool) {
        UIView.performAnimated(animated: animated) { self.alpha = alpha }
    }
    
    public func setTransform(transform: CGAffineTransform, animated: Bool) {
        UIView.performAnimated(animated: animated) { self.transform = transform }
    }
    
    public func setBackgroundColor(backgroundColor: UIColor, animated: Bool) {
        UIView.performAnimated(animated: animated) { self.backgroundColor = backgroundColor }
    }
    
    public func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subView in self.subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
    
    // MARK: - QuartzCore
    
    public func setBorder(_ color: UIColor = UIColor.white, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    @IBInspectable public var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable public var circled: Bool {
        set {
            cornerRadius = newValue ? bounds.height / 2.0 : 0
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.cornerRadius = newValue ? self.bounds.height / 2.0 : 0
            }
        }
        get {
            return cornerRadius == bounds.height / 2.0
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.opacity }
    }
    
    public func fadeIn(_ duration: TimeInterval = 1.0,
                       alpha: CGFloat = 1.0,
                       completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.alpha = alpha
        }, completion: completion)
    }
    
    public func fadeOut(_ duration: TimeInterval = 1.0,
                        alpha: CGFloat = 0.0,
                        completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut, animations: {
                        self.alpha = alpha
        }, completion: completion)
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func setGradientView(topColor: UIColor, bottomColor: UIColor) {
        let gradientView = CAGradientLayer()
        gradientView.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientView.locations = [0.0, 1.0]
        gradientView.frame = self.frame
        self.layer.insertSublayer(gradientView, at: 0)
    }
    
    var imageRendered: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
    
    func animate(reversed: Bool = false,
                 initialAlpha: CGFloat = 0.0,
                 finalAlpha: CGFloat = 1.0,
                 delay: Double = 0.0,
                 duration: TimeInterval = 2.0,
                 backToOriginalForm: Bool = false) {
        
        let transformFrom = transform
        var transformTo = transform
        
         transformTo = transformTo.concatenating(CGAffineTransform(translationX: 0, y: -10))
        
        if reversed == false {
            transform = transformTo
        }
        
        alpha = initialAlpha
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.3,
                           options: [.curveLinear, .curveEaseInOut],
                           animations: { [weak self] in
                            self?.transform = reversed == true ? transformTo : transformFrom
                            self?.alpha = finalAlpha
                }, completion: { (_) in
                    if backToOriginalForm == true {
                        UIView.animate(withDuration: 0.35,
                                       delay: 0.0,
                                       options: [.curveLinear, .curveEaseInOut],
                                       animations: { [weak self] in
                                        self?.transform = .identity
                            }, completion: nil)
                    }
            })
        }
    }
}
