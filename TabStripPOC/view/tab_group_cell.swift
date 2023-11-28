//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import UIKit

class TabGroupCell: TabStripCell {
  
    private let titleLabel : UILabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame:frame)
        type = TabStripItemType.TabGroupItem
        layer.borderColor = UIColor.orange.cgColor
        layer.cornerRadius = TabStripConstants.TabItem.cornderRadius
        layer.borderWidth = 1;
        
        configureTitleLabel()
        
        let contentView = self.contentView
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TabStripConstants.groupItem.titleInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TabStripConstants.groupItem.titleInset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    // MARK: - UICollectionViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        isSelected = false
    }
    
    // MARK: - Private
    
    private func configureTitleLabel() {
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
  
  // MARK: - Public

  public static func estimatedWidth(_ text: String) -> CGFloat {
      let label = UILabel(frame: .zero)
      label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
      label.text = text
    return label.sizeThatFits(.zero).width + (2 * TabStripConstants.groupItem.titleInset)
  }
  
}
