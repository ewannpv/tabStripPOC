//
//  tab_strip_new_tab_button_delegate.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 23/11/2023.
//

import Foundation

// Informs the receiver of actions on the new tab button.
protocol TabStripNewTabButtonDelegate {
    // Informs the receiver that the new tab button was tapped
    func newTabButtonTapped()
}
