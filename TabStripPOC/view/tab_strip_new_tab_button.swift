//
//  tab_strip_new_tab_button.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 23/11/2023.
//

import UIKit

class TabStripNewTabButton: UIView {
    private let button : UIButton = UIButton(type: .custom)
    var delegate : TabStripNewTabButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 1;
        
        configureButton()

        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    // MARK: - Private
    
    @objc func buttonTapped() {
        delegate?.newTabButtonTapped()
    }
    
    private func configureButton() {
        
        let closeSymbol = UIImage(systemName: "xmark")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(closeSymbol, for: .normal)
        button.tintColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
}
