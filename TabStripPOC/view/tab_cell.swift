//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import UIKit

class TabCell: TabStripCell {
    private let closeButton : UIButton = UIButton(type: .custom)
    private let titleLabel : UILabel = UILabel()
    private let faviconView : UIImageView = UIImageView(image: UIImage(named:"chrome.product.cr"))
    
    static let kFaviconSize: CGFloat = 16.0
    static let kXmarkSymbolPointSize: NSInteger = 13
    static let kFaviconLeadingMargin: CGFloat = 10
    static let kCloseButtonMargin: CGFloat = 10
    static let kTitleInset: CGFloat = 10.0
    static let kFontSize: CGFloat = 14.0
    
  private var grouped : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        isSelected = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = TabStripConstants.TabItem.cornderRadius
        layer.borderWidth = 1;
        clipsToBounds = true
        
        configureFaviconView()
        configureCloseButton()
        configureTitleLabel()
        
        let contentView = self.contentView
        contentView.addSubview(faviconView)
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            faviconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TabCell.kFaviconLeadingMargin),
            faviconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            faviconView.widthAnchor.constraint(equalToConstant: TabCell.kFaviconSize),
            faviconView.heightAnchor.constraint(equalTo: faviconView.widthAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TabCell.kCloseButtonMargin),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: TabCell.kFaviconSize),
            closeButton.heightAnchor.constraint(equalTo: faviconView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: faviconView.trailingAnchor, constant: TabCell.kTitleInset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setFaviconImage(_ image: UIImage?) {
        faviconView.image = image
    }
  
  func setGrouped(_ grouped : Bool) {
    self.grouped = grouped
    layer.borderColor = grouped ? UIColor.orange.cgColor :  UIColor.black.cgColor
  }
    
    // MARK: - UICollectionViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
        faviconView.image = nil
        titleLabel.text = nil
        grouped = false
    }
    
    
    // MARK: - Private
    
    @objc func closeButtonTapped() {
        delegate?.closeButtonTappedFor(cell: self)
    }
    
    private func configureFaviconView() {
        faviconView.translatesAutoresizingMaskIntoConstraints = false
        faviconView.contentMode = .scaleToFill
        faviconView.tintColor = UIColor.gray

    }
    
    private func configureCloseButton() {
        let closeSymbol = UIImage(systemName: "xmark")
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(closeSymbol, for: .normal)
        closeButton.tintColor = UIColor.gray
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
}
