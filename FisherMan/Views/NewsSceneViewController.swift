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
        layout.itemSize = CGSize(width: Constants.screenWidth - 40, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.newsCollectionViewCell)
        self.view.add(collectionView, layoutBlock: { $0.edges() })
        return collectionView
    }()
    
    override func setupUI() {
        view.backgroundColor = .white
    }
    
    override func setupBindings() {
        viewModel?.indicatorViewAnimating.drive(spinner.rx.isAnimating).disposed(by: disposeBag)
        viewModel?.loadError.map { _ in false }.drive(errorImageView.rx.isHidden).disposed(by: disposeBag)
        viewModel?.elements?.drive(onNext: { [unowned self] arg in
            Observable.just(arg.0)
                .bind(to: self.newsCollectionView.rx
                    .items(cellIdentifier: Constants.newsCollectionViewCell,
                           cellType: NewsCollectionViewCell.self)) { _, data, cell in
                            cell.setupEntry(new: data)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = specify(UILabel(), {
        $0.numberOfLines = 0
    })
    private let newsImageView = UIImageView()
    
    public func setupEntry(new: NewsModel) {
        add(newsImageView, layoutBlock: { $0.edges() })
        add(titleLabel, layoutBlock: { $0.top(30).leading(20).trailing(20) })
        titleLabel.text = new.title
        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: new.previewImageUrl))
                else { return }
            self.newsImageView.image = UIImage(data: imageData)
        }
    }
}
