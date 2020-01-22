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
    
    override func performAction() {
        dependencies.newsService.getAllNews()
        elements = dependencies.newsService.observeEntries()?.asDriver(onErrorJustReturn: ([], nil))
    }
}
