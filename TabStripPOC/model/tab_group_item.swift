//
//  tab_group_item.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 24/11/2023.
//

import Foundation

class TabGroupItem : TabStripItem {
    var title : String
    
    init(title: String) {
        self.title = title
        super.init(type: TabStripItemType.TabGroupItem)
    }
}
