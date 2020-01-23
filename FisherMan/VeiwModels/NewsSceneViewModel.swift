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
    
    override func performAction() {
        dependencies.newsService.getAllNews()
        
        elements = dependencies.newsService.observeEntries()?
            .map({ $0.0 }).asDriver(onErrorJustReturn: [NewsModel()])
        let localeObservable = LanguageManager.shared.notifyObservable
        newsListObserver = Observable.combineLatest(elements!.asObservable(),
                                                    localeObservable,
                                                    resultSelector: { list, locale -> [NewsModel] in
            return list.filter({ $0.localizationShortName == locale.rawValue })
        })
//        elements = dependencies.newsService.observeEntries()?.do(onNext: { list, changes in
//            list
//        }).map({ $0.0 }).asDriver(onErrorJustReturn: [NewsModel()])
        
//        if let newsEntryObserver = dependencies.newsService.observeEntries() {
//            let localeObserver = LanguageManager.shared.notifyObservable
//            elements = Observable
//                .combineLatest(newsEntryObserver, localeObserver) { news, locale -> [NewsModel]? in
//                    let newsEntries = news.0 as? [NewsModel]
//                    return newsEntries?.filter({ $0.localizationShortName == locale.rawValue })
//            }.asDriver(onErrorJustReturn: [NewsModel()])
//        }
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
