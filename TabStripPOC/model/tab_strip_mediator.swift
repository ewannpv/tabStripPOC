//
//  tab_strip_mediator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

class TabStripMediator: TabStripMutator {
  var items : [TabStripItem]?
  var consumer: TabStripConsumer?
  
  private var groupItem : TabStripItem?
  private var groupItemsVisible : Bool = true
  
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
      if destinationIndex == items?.count {
        items?.append(item)
      } else {
        items?.insert(item, at: destinationIndex)
        
      }
      consumer?.populate(items: items, selectedItem: item)
    }
  }
  
  func groupItem(_ item: TabSwitcherItem) {
    if (groupItem == nil) {
      groupItem = TabGroupItem(title: "Group")
      items?.append(groupItem!)
    }
    let groupItemIndex = items?.firstIndex(of: groupItem!)!
    let itemIndex = (items?.firstIndex(of: item))!
    items?.remove(at: itemIndex)
    if groupItemIndex == items?.count {
      items?.append(item)
    } else {
      items?.insert(item, at: groupItemIndex!)
      
    }
    
    item.grouped = true
    consumer?.populate(items: items, selectedItem: item)
  }
  
  func updateGroupItemVisibility() {
    if (groupItem == nil) {return }
    groupItemsVisible = !groupItemsVisible
    let filtered_items = items?.filter({
      let item = $0
      switch item.type {
      case TabStripItemType.TabGroupItem:
        return true
      case TabStripItemType.TabSwitcherItem: do {
        let tabItem = item as! TabSwitcherItem
        return tabItem.grouped == false || groupItemsVisible
      }
      }})
    consumer?.populate(items: filtered_items, selectedItem: nil)
    
  }
}
