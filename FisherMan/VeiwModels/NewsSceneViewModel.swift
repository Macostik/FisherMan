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

enum NewsCollectionAction {
    case collectionRefreshed(withNews: [NewsModel])
    case newsMarkedForDeletion(_ book: NewsModel)
}

final class NewsSceneViewModel: BaseViewModel<NewsModel> {
    
    public var items: Observable<[NewsModel]>?
    public var reachBottomObserver: Observable<Void>? {
        willSet {
            newValue?.subscribe(onNext: { [unowned self] _ in
                self.dependencies.newsService.getOldNews()?.subscribe().disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
            
        }
    }
    public var deleteObservable = PublishRelay<IndexPath>()
    private let collectionActions = ReplaySubject<NewsCollectionAction>.create(bufferSize: 1)
    
    override func performAction() {
        dependencies.newsService.getAllNews()
        elements = dependencies.newsService.observeEntries()?
            .map({ $0.0 }).asDriver(onErrorJustReturn: [NewsModel()])
        
        items = collectionActions.scan([], accumulator: { news, action -> [NewsModel] in
            switch action {
            case . newsMarkedForDeletion(let new):
                return news.filter { $0 != new }
            case .collectionRefreshed(withNews: let news):
                return news
            }
        }).map { $0.sorted(by: { $0.publicationDate > $1.publicationDate })}
        
        Observable.combineLatest(elements?.asObservable() ?? .empty(),
                                 LanguageManager.shared.notifyObservable,
                                 resultSelector: { list, locale -> [NewsModel] in
                                    return list.filter({ $0.localizationShortName == locale.rawValue })
        }).map { new -> NewsCollectionAction in return .collectionRefreshed(withNews: new) }
            .bind(to: collectionActions)
            .disposed(by: disposeBag)
        
        let newsMarkedForDeletion =  deleteObservable
            .withLatestFrom(items!) { index, items -> NewsModel in
                return items[index.row] }
            .share()
        
        newsMarkedForDeletion
            .map { new -> NewsCollectionAction in return .newsMarkedForDeletion(new) }
            .bind(to: collectionActions)
            .disposed(by: disposeBag)
    }
}
