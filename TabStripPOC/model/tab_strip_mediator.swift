//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

class TabStripMediator: TabStripMutator {
    var items : [TabStripItem]?
    var consumer: TabStripConsumer?

    init() {
        items = []
    }
    
    func addNewItem(item: TabStripItem) {
        items?.append(item)
        consumer?.populate(items: items, selectedItem: item)
    }
    
    func activateItem(item: TabStripItem) {
        consumer?.selectItem(item)
    }
    
    func closeItem(_ item: TabStripItem) {
        if let index = items?.firstIndex(of: item) {
            items?.remove(at: index)
            consumer?.populate(items: items, selectedItem: items?.first)
        }
    }
    
    func moveItem(_ item: TabStripItem, destinationIndex: Int) {
        if let index = items?.firstIndex(of: item) {
            guard let item = items?.remove(at: index) else { return }
            items?.insert(item, at: destinationIndex)
            consumer?.populate(items: items, selectedItem: item)
        }
    }
}
