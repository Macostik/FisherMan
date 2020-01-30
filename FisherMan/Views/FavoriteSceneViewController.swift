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
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Int> = {
        let dataSource = UICollectionViewDiffableDataSource
            <Section, Int>(collectionView: self.favoriteGrid) { collectionView, indexPath, identifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCell.identifier,
                    for: indexPath) as? FavoriteCell else { fatalError("Cannot create new cell") }
                
                cell.setupEntry(identifier)
                return cell
        }
        return dataSource
    }()
    private let snapShot: NSDiffableDataSourceSnapshot<Section, Int> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(Array(0..<100))
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
    
    let titleLabel = specify(UILabel()) {
        $0.textAlignment = .center
        
    }
    public func setupEntry(_ entry: Int) {
        add(titleLabel, layoutBlock: { $0.edges() })
        titleLabel.text = "\(entry)"
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
}
