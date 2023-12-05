//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import UIKit

class TabGroupCell: TabStripCell {
  
    private let titleLabel : UILabel = UILabel()
    private let roundedBackgroundView : UIView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        type = TabStripItemType.TabGroupItem
        layer.borderColor = UIColor.orange.cgColor
        layer.cornerRadius = TabStripConstants.TabItem.cornderRadius
        layer.borderWidth = 1;
        layer.masksToBounds = true
        clipsToBounds = true
        configureTitleLabel()
        configureRoundedBackgroundView()
        
        let contentView = self.contentView
        contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(titleLabel)
        
        let defaultHeightConstraint : NSLayoutConstraint =
        roundedBackgroundView.heightAnchor .constraint(equalTo: contentView.heightAnchor, constant: -2 * TabStripConstants.groupItem.backgroundTiteInset)
        defaultHeightConstraint.priority = .defaultLow
        
        let resizeHeighConstraint : NSLayoutConstraint  =             roundedBackgroundView.heightAnchor.constraint(lessThanOrEqualTo:roundedBackgroundView.widthAnchor)
        resizeHeighConstraint.priority  = .defaultHigh
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo:contentView.leadingAnchor, constant: TabStripConstants.groupItem.backgroundTiteInset),
            roundedBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo:contentView.trailingAnchor, constant: -TabStripConstants.groupItem.backgroundTiteInset),
            defaultHeightConstraint,
            resizeHeighConstraint,
            roundedBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: roundedBackgroundView.leadingAnchor, constant: TabStripConstants.groupItem.titleInset),
            titleLabel.trailingAnchor.constraint(equalTo: roundedBackgroundView.trailingAnchor, constant: -TabStripConstants.groupItem.titleInset),
            titleLabel.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor),
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
    
    private func configureRoundedBackgroundView() {
        roundedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        roundedBackgroundView.backgroundColor = UIColor.orange
        roundedBackgroundView.layer.cornerRadius = 8.0

    }
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
      return label.sizeThatFits(.zero).width + (2 * (TabStripConstants.groupItem.titleInset + TabStripConstants.groupItem.backgroundTiteInset))
  }
  
}
