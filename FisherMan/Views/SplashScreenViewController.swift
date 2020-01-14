//  
//  SplashScreenViewController.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RxGesture
import RxAlamofire
import RealmSwift

class SplashScreenViewController: BaseViewController<SplashSceneViewModel> {
    
    private let splashSreen: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "splashScreen")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    private let fisherManLabel = specify(UILabel(), {
        $0.text = "Fisher Man"
        $0.textColor = .systemBackground
        $0.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
    })
    
    private let copyrightLabel = specify(UILabel(), {
        let currentYear = Calendar.current.component(.year, from: Date())
        $0.text = "Copyright © 2019 - \(currentYear), GYS"
        $0.textColor = .systemBackground
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .center
    })
    
    private let photoLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    
    override func setupUI() {
        view.add(splashSreen, layoutBlock: { $0.edges() })
        view.add(fisherManLabel, layoutBlock: { $0.bottom(120).centerX() })
        view.add(copyrightLabel, layoutBlock: { $0.bottom(20).centerX() })
        animateAvatarLayer()
    }
    
    override func setupBindings() {}
    
    private func animateAvatarLayer() {
        let imageWidth = 128
        guard let image = UIImage(named: "splashAvatar") else { return }
        photoLayer.contents = image.cgImage
        photoLayer.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth)
        photoLayer.position = CGPoint(x: view.center.x + 1, y: view.frame.minY + 330)
        photoLayer.mask = maskLayer
        maskLayer.path = UIBezierPath(ovalIn:
            CGRect(x: imageWidth/2, y: imageWidth/2, width: 0, height: 0)).cgPath
        view.layer.addSublayer(photoLayer)
        
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = 0.25
        morphAnimation.beginTime = CACurrentMediaTime() + 2.0
        morphAnimation.fillMode = .forwards
        morphAnimation.isRemovedOnCompletion = false
        morphAnimation.delegate = self
        morphAnimation.toValue = UIBezierPath(ovalIn: CGRect(x: 0,
                                                             y: 0,
                                                             width: imageWidth,
                                                             height: imageWidth)).cgPath
        maskLayer.add(morphAnimation, forKey: nil)
    }
}

extension SplashScreenViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.viewModel?.animateCompletionObserver.onNext(())
    }
}
