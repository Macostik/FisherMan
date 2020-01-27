//  
//  NewsSceneViewController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.12.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import RxDataSources

typealias Section = AnimatableSectionModel<String, NewsModel>
typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfArticles>

class NewsSceneViewController: BaseViewController<NewsSceneViewModel> {
    
    private lazy var spinner = specify(UIActivityIndicatorView(style: .medium), {
        $0.color = self.view.tintColor
        $0.startAnimating()
        self.view.add($0, layoutBlock: { $0.center() })
    })
    
    private lazy var errorImageView = specify(UIImageView(), {
        let configuration = UIImage.SymbolConfiguration(pointSize: 75, weight: .medium)
        $0.image = UIImage(systemName: Constants.errorCloudImage, withConfiguration: configuration)
        $0.isHidden = true
        self.view.add($0, layoutBlock: { $0.center() })
    })
    
    private lazy var newsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: Constants.screenWidth - 40, height: 400)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.newsCollectionViewCell)
        self.view.add(collectionView, layoutBlock: { $0.edges() })
        return collectionView
    }()
    
    private lazy var dataSource: DataSource = {
        let animationConfiguration = AnimationConfiguration(insertAnimation: .automatic,
                                                            reloadAnimation: .automatic,
                                                            deleteAnimation: .automatic)
        return DataSource(animationConfiguration: animationConfiguration,
                          configureCell: {  _, collectionView, indexPath, data in
                            let cell = collectionView
                                .dequeueReusableCell(withReuseIdentifier: Constants.newsCollectionViewCell,
                                                     for: indexPath) as? NewsCollectionViewCell
                            cell?.setupEntry(data)
                            return cell ?? UICollectionViewCell()
        })
    }()
    
    override func setupUI() {
        view.backgroundColor = .white
    }
    
    override func setupBindings() {
        viewModel?.indicatorViewAnimating.drive(spinner.rx.isAnimating).disposed(by: disposeBag)
        viewModel?.loadError.map({ _ in false }).drive(errorImageView.rx.isHidden).disposed(by: disposeBag)
        viewModel?.reachBottomObserver = newsCollectionView.rx.reachedBottom().asObservable()
        viewModel?.items?.map({ [SectionOfArticles(items: $0)] })
            .bind(to: newsCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        newsCollectionView.rx.itemSelected
            .bind(to: viewModel!.deleteObservable)
            .disposed(by: disposeBag)
    }
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = specify(UILabel(), {
        $0.numberOfLines = 0
    })
    private let newsImageView = specify(UIImageView(), {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
    })
    
    public func setupEntry(_ data: NewsModel) {
        add(newsImageView, layoutBlock: { $0.edges() })
        add(titleLabel, layoutBlock: { $0.top(30).leading(20).trailing(20) })
        titleLabel.text = data.title
        self.newsImageView.sd_setImage(with: URL(string: data.previewImageUrl))
    }
}
