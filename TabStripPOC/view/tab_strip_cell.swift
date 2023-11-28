//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import UIKit

class TabStripCell: UICollectionViewCell {
  var type: TabStripItemType = TabStripItemType.TabSwitcherItem
    var delegate: TabStripCellDelegate?
    
    // MARK: - Accessor
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.lightGray
        }
    }
    
    // MARK: - Public Methods

    public func dragPreview() -> UIView {
        let preview : UIView = self as UIView
        preview.layer.cornerRadius = TabStripConstants.TabItem.previewCornderRadius
        preview.backgroundColor = UIColor.clear
        return preview
    }
    
    public func DragDone() {
        self.layer.cornerRadius = TabStripConstants.TabItem.cornderRadius
    }
    
    // MARK: - UICollectionViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        layer.cornerRadius = TabStripConstants.TabItem.cornderRadius
    }
}
