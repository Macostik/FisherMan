//
//  Reactive+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 23.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: LanguageManager {
    var toggle: Binder<Bool> {
        return Binder(self.base) { langaugeManager, toggle in
            langaugeManager.locale = toggle ? .ru : .en
        }
    }
}

extension Reactive where Base: UILabel {
    public var select: Binder<Bool> {
        return Binder(self.base) { label, selected in
            label.textColor = selected ? .black : .green
        }
    }
}

public extension Reactive where Base: UIScrollView {

    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top -
                self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIViewController {
    public func present(_ viewControllerToPresent: UIViewController, animated: Bool) -> Observable<Void> {
        return Observable.create { observer in
            self.base.present(viewControllerToPresent, animated: animated, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }
}

extension Driver {
    func flatMapOnBackground<R>(scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background),
                                work: @escaping (Element) -> R) -> Driver<R> {
        return self.flatMapLatest { x in
            Observable.just(x)
                .observeOn(scheduler)
                .map(work)
                .asDriver(onErrorDriveWith: Driver<R>.never())
        }
    }
}
