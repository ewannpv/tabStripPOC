//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//


/// Consumer protocol for the TabStrip.
protocol TabStripConsumer {
    
    /// Tells the consumer to replace its current set of items with `items` and updates the selected
    /// item to be `selectedItem`. The selected item must be in the `items`.
    func populate(items: [TabStripItem]?, selectedItem: TabStripItem?)
    
    /// Tells the consumer to select `item`.
    func selectItem(_ item: TabStripItem?)
    
    /// Reloads `item`'s content.
    func reloadItem(_ item: TabStripItem?)
    
    /// Replaces `oldItem` by `newItem`.
    /// The nullability is here for Objective-C compatibility. If one of them is nil, the consumer will do nothing.
    func replaceItem(_ oldItem: TabStripItem?, withItem newItem: TabStripItem?)    
}
