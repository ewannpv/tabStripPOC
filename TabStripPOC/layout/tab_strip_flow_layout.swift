//
//  tab_strip_layout.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 27/11/2023.
//

import Foundation


import UIKit

/// Layout used for the TabStrip.
class TabStripFlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    private var indexPathsOfDeletingItems : [IndexPath] = []
    private var indexPathsOfInsertingItems : [IndexPath] = []
    
    weak var dataSource:
    UICollectionViewDiffableDataSource<TabStripViewController.Section, TabStripItem>?
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumInteritemSpacing = TabStripConstants.TabItem.horizontalSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        super.prepare()

        guard let collectionView = self.collectionView, let snapshot = dataSource?.snapshot() else {return }


            let itemCount = CGFloat(snapshot.itemIdentifiers(inSection: .tabs).count)
            if (itemCount == 0) {
                return;
            }
            
            let collectionViewWidth: CGFloat = CGRectGetWidth(collectionView.bounds);
            let itemSpacingSum: CGFloat = minimumInteritemSpacing * (itemCount - 1);
            
            var itemWidth: CGFloat =
            (collectionViewWidth - itemSpacingSum) / itemCount;
            itemWidth = max(itemWidth, TabStripConstants.TabItem.minWidth)
            itemWidth = min(itemWidth, TabStripConstants.TabItem.maxWidth)
            
            itemSize = CGSize(width: itemWidth, height: TabStripConstants.TabItem.height)
    }
    
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        indexPathsOfDeletingItems = []
        indexPathsOfInsertingItems = []
        for item in updateItems {
            switch item.updateAction {
            case .insert:
                indexPathsOfInsertingItems.append(item.indexPathAfterUpdate!)
                break
            case .delete:
                indexPathsOfDeletingItems.append(item.indexPathBeforeUpdate!)
                break
            default:
                break
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {return nil }
        
        if (!indexPathsOfInsertingItems.contains(itemIndexPath)){
            return attributes;
        }
        // TODO(crbug.com/820410) : Polish the animation, and put constants where they
        // belong.
        // Cells being inserted start faded out, scaled down, and drop downwards
        // slightly.
        attributes.alpha = 0.0;
        var transform : CGAffineTransform =
        CGAffineTransformScale(attributes.transform, /*sx=*/0.9, /*sy=*/0.9);
        transform = CGAffineTransformTranslate(transform, /*tx=*/0,
                                               /*ty=*/attributes.size.height * 0.1);
        attributes.transform = transform;
        return attributes;
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes : UICollectionViewLayoutAttributes? = super.layoutAttributesForItem(at: indexPath)
        return attributes
    }
}
