//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//


import UIKit

let kTabStripItemHeight :CGFloat = 39
let kTabStripItemMinWidth :CGFloat = 80
let kTabStripItemMaxWidth :CGFloat = 150


/// Layout used for the TabStrip.
class TabStripCompositionalLayout: UICollectionViewCompositionalLayout {
    private var indexPathsOfDeletingItems : [IndexPath] = []
    private var indexPathsOfInsertingItems : [IndexPath] = []
    
    // The data source used for the collection view.
    weak var dataSource:
    UICollectionViewDiffableDataSource<TabStripViewController.Section, TabStripItem>?
    
    required init() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal

        // Use a `futureSelf` variable as the super init requires a closure and as
        // init is not instantiated yet, we can't use it.
        weak var futureSelf: TabStripCompositionalLayout?
        super.init(
            sectionProvider: {
                (
                    sectionIndex: Int,
                    layoutEnvironment: NSCollectionLayoutEnvironment
                ) -> NSCollectionLayoutSection? in
                return futureSelf?.getSection(
                    sectionIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
            }, configuration: configuration)
        futureSelf = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Private
    
    func getSection(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        
        var subitems: [NSCollectionLayoutItem] = []

        let tabGroupItem = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(
            widthDimension: .estimated(50.0),
            heightDimension: .fractionalHeight(1.0)))
        tabGroupItem.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)

        let tabSwitcherItem = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        tabSwitcherItem.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)

        guard let  snapshot = dataSource?.snapshot() else { return nil }
        for tabStripItem : TabStripItem in snapshot.itemIdentifiers {
            switch tabStripItem.type {
            case .TabGroupItem:
                subitems.append(tabGroupItem)
                break
            case .TabSwitcherItem:
                subitems.append(tabSwitcherItem)
                break
            }
        }

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .uniformAcrossSiblings(estimate: 120),
                heightDimension: .fractionalHeight(1.0)),
            subitems: subitems)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // MARK: - UICollectionViewLayout
    
    override func prepare() {
        super.prepare()
    }
    
    // Calculate cell width based on cell data
    func calculateWidth() -> CGFloat {
        return CGFloat( 150 - (self.collectionView?.numberOfItems(inSection: 0))! * 2)
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
}
