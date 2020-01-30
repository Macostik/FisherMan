//  
//  FavoriteSceneViewController.swift
//  FisherMan
//
//  Created by Yura Granchenko on 20.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteSceneViewController: BaseViewController<FavoriteSceneViewModel> {
    
    enum Section {
           case main
    }
    
    private lazy var favoriteGrid =
        specify(UICollectionView(frame: .zero,
                                 collectionViewLayout: self.collectionViewLayout)) {
                                    $0.backgroundColor = .systemBackground
                                    $0.register(FavoriteCell.self,
                                                forCellWithReuseIdentifier: FavoriteCell.identifier)
    }
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let leadingSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                                     heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingSize)
            let trailingSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingSize)
            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                           heightDimension: .fractionalHeight(1.0))
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                                 subitem: trailingItem,
                                                                 count: 2)
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.25)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        return layout
    }()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, FavoriteModel> = {
        let dataSource = UICollectionViewDiffableDataSource
            <Section, FavoriteModel>(collectionView: self.favoriteGrid) { collectionView, indexPath, entry in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCell.identifier,
                    for: indexPath) as? FavoriteCell else { fatalError("Cannot create new cell") }
                cell.setupEntry(entry)
                return cell
        }
        return dataSource
    }()
    private let snapShot: NSDiffableDataSourceSnapshot<Section, FavoriteModel> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavoriteModel>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(FavoriteModel.entries())
        return snapshot
    }()
    
    override func setupUI() {
        view.add(favoriteGrid, layoutBlock: { $0.edges() })
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    override func setupBindings() {
//        viewModel?.indicatorViewAnimating.drive(<#drive#>),
//        viewModel?.elements.drive(<#drive#>),
//        viewModel?.loadError.drive(onNext: {<#drive#>}),
    }
}

final class FavoriteCell: UICollectionViewCell, CellIdentifierable {
    
    let imageView = specify(UIImageView()) {
        $0.contentMode = .scaleAspectFill
        
    }
    public func setupEntry(_ entry: FavoriteModel) {
        add(imageView, layoutBlock: { $0.edges() })
        imageView.sd_setImage(with: entry.concatURL)
    }
}
