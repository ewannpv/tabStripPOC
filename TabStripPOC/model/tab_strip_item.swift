//
//  tab_switcher_item.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 24/11/2023.
//

import Foundation

enum TabStripItemType {
    case TabGroupItem, TabSwitcherItem
}

class TabStripItem : Hashable {
    var identifier : String
    var type : TabStripItemType

    init(type: TabStripItemType) {
        self.identifier = UUID().uuidString
        self.type = type
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: TabStripItem, rhs: TabStripItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
