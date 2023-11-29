//
//  tab_strip_constants.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 27/11/2023.
//

import Foundation


struct TabStripConstants {
    static let fontSize: CGFloat = 14.0
    static let height :CGFloat = 39
    struct TabItem {
        static let height :CGFloat = 39
        static let minWidth :CGFloat = 80
        static let maxWidth :CGFloat = 150
        static let horizontalSpacing: CGFloat = 6
        static let cornderRadius: CGFloat = 4

        static let previewCornderRadius: CGFloat = 12
    }
    
    
    struct groupItem {
        static let titleInset: CGFloat = 6.0
    }
    
    struct NewTabBtn {
        static let width: CGFloat = 50
    }
}

