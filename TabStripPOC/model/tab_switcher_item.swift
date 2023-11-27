//
//  tab_switcher_item.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import Foundation

class TabSwitcherItem : TabStripItem {
    var title : String
    var symbolName : String
    var grouped : Bool = false
    
    init(title: String, symbolName: String) {
    
        self.title = title
        self.symbolName = symbolName
        super.init(type: TabStripItemType.TabSwitcherItem)
    }
}
