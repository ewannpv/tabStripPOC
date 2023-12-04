//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//


import UIKit

/// View Controller displaying the TabStrip.
@objcMembers
class TabStripViewController: UIViewController, TabStripCellDelegate,TabStripConsumer,
                              TabStripNewTabButtonDelegate
{
    // The enum used by the data source to manage the sections.
    enum Section: Int {
        case tabs
    }
    
    private let layout: TabStripFlowLayout
    // The CollectionView used to display the items.
    private let collectionView: UICollectionView
    private let newTabButton: TabStripNewTabButton = TabStripNewTabButton(frame: .zero)
    private var newTabCount: Int = 0
    
    // The DataSource for this collection view.
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, TabStripItem>?
    private var tabSwitcherCellRegistration: UICollectionView.CellRegistration<TabCell, TabSwitcherItem>?
    private var tabGroupCellCellRegistration: UICollectionView.CellRegistration<TabGroupCell, TabGroupItem>?
    
    private var draggedItems : [TabStripCell] = []
    
    var mutator: TabStripMutator?
    
    
    
    init() {
        layout = TabStripFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.delegate = self
        createRegistrations()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, TabStripItem>(
            collectionView: collectionView
        ) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: TabStripItem)
            -> UICollectionViewCell? in
            return self.getCell(
                collectionView: collectionView, indexPath: indexPath, itemIdentifier: itemIdentifier)
        }
        layout.dataSource = diffableDataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        self.view.addSubview(collectionView)
        self.view.addSubview(newTabButton)
        newTabButton.delegate = self
        
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: newTabButton.trailingAnchor),
            self.view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            
            self.collectionView.trailingAnchor.constraint(equalTo: newTabButton.leadingAnchor),
            newTabButton.widthAnchor.constraint(equalToConstant: TabStripConstants.NewTabBtn.width),
            newTabButton.heightAnchor.constraint(equalToConstant: TabStripConstants.height),
        ])
    }
    
    // MARK: - TabStripConsumer
    
    func populate(items: [TabStripItem]?, selectedItem: TabStripItem?) {
        guard let items = items else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, TabStripItem>()
        snapshot.appendSections([.tabs])
        snapshot.appendItems(items, toSection: .tabs)
        snapshot.reconfigureItems(items)
        layout.needUpdate = true
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
        layout.needUpdate = false
        selectItem(selectedItem)
    }
    
    func selectItem(_ item: TabStripItem?) {
        guard let item = item, let diffableDataSource = diffableDataSource else {
            return
        }
        
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in indexPaths {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
        
        let indexPath = diffableDataSource.indexPath(for: item)
      layout.selectedIndexPath = indexPath
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [UICollectionView.ScrollPosition.centeredHorizontally])
    }
    
    func reloadItem(_ item: TabStripItem?) {
        guard let item = item, let diffableDataSource = diffableDataSource else {
            return
        }
        
        var snapshot = diffableDataSource.snapshot()
        snapshot.reconfigureItems([item])
        layout.needUpdate = true
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        layout.needUpdate = false
    }
    
    func replaceItem(_ oldItem: TabStripItem?, withItem newItem: TabStripItem?) {
        guard let oldItem = oldItem, let newItem = newItem, let diffableDataSource = diffableDataSource
        else {
            return
        }
        
        var snapshot = diffableDataSource.snapshot()
        snapshot.insertItems([newItem], beforeItem: oldItem)
        snapshot.deleteItems([oldItem])
        layout.needUpdate = true
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        layout.needUpdate = false
    }
    
    // MARK: - TabStripCellDelegate
    
    func closeButtonTappedFor(cell: TabStripCell?) {
        guard let cell = cell, let diffableDataSource = diffableDataSource else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        guard let item = diffableDataSource.itemIdentifier(for: indexPath)else {
            return
        }
        mutator?.closeItem(item)
    }
    
    // MARK: - TabStripNewTabButtonDelegate
    
    func newTabButtonTapped() {
        mutator?.addNewItem(item: TabSwitcherItem(title: "Tab Strip \(newTabCount)", symbolName: ""))
        newTabCount += 1
    }
    // MARK: - Private
    
    /// Creates the registrations of the different cells used in the collection view.
    func createRegistrations() {
        tabSwitcherCellRegistration = UICollectionView.CellRegistration<TabCell, TabSwitcherItem> {
            (cell, indexPath, item) in
            cell.setTitle(item.title)
            cell.setGrouped(item.grouped)
            //cell.setFaviconImage(UIImage(systemName: item.symbolName))
            cell.delegate = self
        }
        tabGroupCellCellRegistration  = UICollectionView.CellRegistration<TabGroupCell, TabGroupItem> {
            (cell, indexPath, item) in
            cell.setTitle(item.title)
            cell.delegate = self
        }
    }
    
    /// Retuns the cell to be used in the collection view.
    func getCell(
        collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: TabStripItem
    ) -> UICollectionViewCell? {
        guard let tabSwitcherCellRegistration = tabSwitcherCellRegistration, let tabGroupCellCellRegistration = tabGroupCellCellRegistration
        else {
            return nil
        }
        switch itemIdentifier.type {
        case .TabGroupItem:
            return collectionView.dequeueConfiguredReusableCell(
                using: tabGroupCellCellRegistration,
                for: indexPath,
                item: itemIdentifier as? TabGroupItem)
        case .TabSwitcherItem:
            return collectionView.dequeueConfiguredReusableCell(
                using: tabSwitcherCellRegistration,
                for: indexPath,
                item: itemIdentifier as? TabSwitcherItem)
        }
    }
    
}

// MARK: - UICollectionViewDragDelegate

extension TabStripViewController : UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let diffableDataSource = diffableDataSource else {
            return []
        }
        let item = diffableDataSource.itemIdentifier(for: indexPath)
        let collectionViewItem = collectionView.cellForItem(at: indexPath) as! TabStripCell
        
        let itemProvider = NSItemProvider(object: "Dragged item" as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = item
        dragItem.previewProvider = {
            return UIDragPreview(view: collectionViewItem.dragPreview())
        }
        
        draggedItems = [collectionViewItem]
        return [dragItem]
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dragSessionDidEnd session: UIDragSession
    ) {
        for item in draggedItems{
            item.DragDone()
        }
        draggedItems = []
    }
}

// MARK: - UICollectionViewDropDelegate

extension TabStripViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item  = coordinator.items.first else { return }
        guard let tabStripItem : TabStripItem = item.dragItem.localObject as? TabStripItem else { return }
        
        var destinationIndex : Int = collectionView.numberOfItems(inSection: 0)
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndex = indexPath.row
        }
        
        mutator?.moveItem(tabStripItem, destinationIndex: destinationIndex)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TabStripViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 16, *) {
        } else {
            self.collectionView(collectionView, performPrimaryActionForItemAt: indexPath)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView, performPrimaryActionForItemAt indexPath: IndexPath
    ) {
        guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        if item.type == TabStripItemType.TabGroupItem {
            mutator?.updateGroupItemVisibility()
        } else {
            selectItem(item)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return layout.calculcateCellSize(indexPath: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard let item = diffableDataSource?.itemIdentifier(for: indexPath) else { return UIContextMenuConfiguration() }
        
        let groupAction =
        UIAction(title: NSLocalizedString("Group", comment: ""),
                 image: UIImage(systemName: "arrow.up.square")) { action in
            self.mutator?.groupItem(item as! TabSwitcherItem)
        }
        let unGroupAction =
        UIAction(title: NSLocalizedString("DuplicateTitle", comment: ""),
                 image: UIImage(systemName: "plus.square.on.square")) { action in
            // TODO
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return UIMenu(title: "", children: [groupAction, unGroupAction])
        }
    }

}
