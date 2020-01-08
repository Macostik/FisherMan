//
//  BaseViewController.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RealmSwift

let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
let navigationBarHeight = 44 + (keyWindow?.safeAreaInsets.bottom ?? 0)
let tabBarHeight = 44 + (keyWindow?.safeAreaInsets.bottom ?? 0)

protocol ViewModelBased: class {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

public protocol BaseInstance: class {}

public extension BaseInstance where Self: UIViewController {
    static func instance() -> Self {
        return Self()
    }
}

extension BaseInstance where Self: UIViewController & ViewModelBased {
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self.instance()
        viewController.viewModel = viewModel
        return viewController
    }
}

private func performWhenLoaded
    <O, T: BaseViewController<O, BaseViewModel<O>>>(controller: T, block: @escaping (T) -> Void) {
    controller.whenLoaded { [weak controller] in
        if let controller = controller {
            block(controller)
        }
    }
}

class BaseViewController<O: Object, T: BaseViewModel<O>>: UIViewController, ViewModelBased, BaseInstance {
    
    typealias ViewModel = T
    var viewModel: T?
     
    var screenName: String = ""
    internal let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenName = NSStringFromClass(type(of: self))
        Logger.info("\(screenName) create")
        setupUI()
        setupBindings()
        
        if !whenLoadedBlocks.isEmpty {
            whenLoadedBlocks.forEach({ $0() })
            whenLoadedBlocks.removeAll()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LastVisibleScreen.lastAppearedScreenName = screenName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        Logger.info("\(NSStringFromClass(type(of: self))) deinit")
    }
    
    private var whenLoadedBlocks = [(() -> Void)]()
       
       func whenLoaded(block: @escaping (() -> Void)) {
           if isViewLoaded {
               block()
           } else {
               whenLoadedBlocks.append(block)
           }
       }
    
    internal func setupUI() {}
    
    internal func setupBindings() {}
}
