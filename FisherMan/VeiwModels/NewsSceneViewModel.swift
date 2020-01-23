//  
//  NewsSceneViewModel.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NewsSceneViewModel: BaseViewModel<NewsModel> {
    
    public var newsListObserver: Observable<[NewsModel]>?
    public var reachBottomObserver: Observable<Void>? {
        willSet {
            newValue?.subscribe(onNext: { [unowned self] _ in
                self.dependencies.newsService.getOldNews()?.subscribe().disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
            
        }
    }
    
    override func performAction() {
        dependencies.newsService.getAllNews()
        elements = dependencies.newsService.observeEntries()?
            .map({ $0.0 }).asDriver(onErrorJustReturn: [NewsModel()])
        newsListObserver =
            Observable.combineLatest(elements?.asObservable() ?? .empty(),
                                     LanguageManager.shared.notifyObservable,
                                     resultSelector: { list, locale -> [NewsModel] in
                                        return list.filter({ $0.localizationShortName == locale.rawValue })
                                            .sorted(by: { $0.publicationDate > $1.publicationDate })
            })
    }
}

extension IndexPath {
    static func fromRow(_ row: Int) -> IndexPath {
    return IndexPath(row: row, section: 0)
  }
}

extension UICollectionView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        performBatchUpdates({
            insertItems(at: insertions.map(IndexPath.fromRow))
            deleteItems(at: deletions.map(IndexPath.fromRow))
            reloadItems(at: updates.map(IndexPath.fromRow))
        })
    }
}
