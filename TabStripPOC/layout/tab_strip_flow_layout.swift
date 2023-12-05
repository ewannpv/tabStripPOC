//
//  tab_strip_layout.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 27/11/2023.
//

import Foundation


import UIKit

/// Layout used for the TabStrip.
class TabStripFlowLayout: UICollectionViewFlowLayout {
    public var needUpdate : Bool = true
    public var tabCellSize : CGSize = .zero
  public var selectedIndexPath: IndexPath?
    private var indexPathsOfDeletingItems : [IndexPath] = []
    private var indexPathsOfInsertingItems : [IndexPath] = []
    
    weak var dataSource:
    UICollectionViewDiffableDataSource<TabStripViewController.Section, TabStripItem>?
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumInteritemSpacing = TabStripConstants.TabItem.horizontalSpacing
        minimumLineSpacing = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        if (needUpdate){
            calculateTabCellSize()
        }
        super.prepare()
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
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = collectionView else { return nil }

        guard let cell : TabStripCell = (collectionView.cellForItem(at: indexPath) as? TabStripCell) else { return  layoutAttributes }
        if (cell.type == TabStripItemType.TabSwitcherItem && cell.isSelected) {
            cell.isHidden = false
            let contentOffset = collectionView.contentOffset
    
            var origin = layoutAttributes.frame.origin
            layoutAttributes.zIndex = 100
            
            let maxOrigin = (collectionView.bounds.size.width) - layoutAttributes.frame.size.width
        
            origin.x = max(origin.x, contentOffset.x)
            origin.x =  min(origin.x, contentOffset.x + maxOrigin)
    
            layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
        } else {
            var frame = layoutAttributes.frame
            let currentWidth = frame.width
            let contentOffset = collectionView.contentOffset

            if (frame.origin.x  < contentOffset.x && frame.origin.x + currentWidth > contentOffset.x) {
                let contentOffset = collectionView.contentOffset

                
                frame.origin.x = max(frame.origin.x, contentOffset.x)
                frame.size.width = min(frame.size.width - (abs(frame.origin.x - layoutAttributes.frame.origin.x)), frame.size.width)
            }
            let collectionViewSize = (collectionView.bounds.size.width)

            if (frame.origin.x < collectionViewSize + contentOffset.x  && frame.origin.x + layoutAttributes.frame.size.width > collectionViewSize + contentOffset.x) {
               frame.size.width =  min(abs(frame.origin.x - (collectionViewSize + contentOffset.x)), frame.size.width)
            }

            layoutAttributes.frame = frame
        }
        
        return layoutAttributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var computedAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        computedAttributes = computedAttributes.compactMap { layoutAttribute in
            layoutAttributesForItem(at: layoutAttribute.indexPath)
        }
        
        if(selectedIndexPath != nil) {
          let attr = layoutAttributesForItem(at: selectedIndexPath!)
          if(attr != nil) {
            computedAttributes.append(attr!)
          }
        }
        return computedAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
       return true
    }
    
    // MARK: - Private
    
    private func calculateTabCellSize() {
        guard let collectionView = self.collectionView, let snapshot = dataSource?.snapshot() else {return }
        
        var groupCellWidthSum : CGFloat = 0
        var tabCellCount : CGFloat = 0
        let cellCount : CGFloat = CGFloat(snapshot.itemIdentifiers.count)
        
        if (cellCount == 0) {
            return;
        }
        
        for item in snapshot.itemIdentifiers {
            if (item.type == TabStripItemType.TabGroupItem){
                groupCellWidthSum += getGroupCellWidth(item: item)
            } else {
                tabCellCount += 1
            }
        }
        
        let collectionViewWidth: CGFloat = CGRectGetWidth(collectionView.bounds);
        let itemSpacingSum: CGFloat = minimumInteritemSpacing * (cellCount - 1);
        
        var itemWidth: CGFloat =
        (collectionViewWidth - itemSpacingSum - groupCellWidthSum) / tabCellCount;
        itemWidth = max(itemWidth, TabStripConstants.TabItem.minWidth)
        itemWidth = min(itemWidth, TabStripConstants.TabItem.maxWidth)
        
        tabCellSize = CGSize(width: itemWidth, height: TabStripConstants.TabItem.height)
    }
    
    // MARK: - Private
    
    private func getGroupCellWidth(item: TabStripItem)  -> CGFloat {
        guard let groupItem = item as? TabGroupItem else {return 0}
        return TabGroupCell.estimatedWidth(groupItem.title)
    }
    // MARK: - Public
    
    public func calculcateCellSize(indexPath: IndexPath) -> CGSize {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return .zero}
        
        switch item.type {
        case TabStripItemType.TabSwitcherItem:
            return tabCellSize
        case TabStripItemType.TabGroupItem:
            return CGSize(width: getGroupCellWidth(item: item), height: TabStripConstants.TabItem.height)
        }
    }
    
}

