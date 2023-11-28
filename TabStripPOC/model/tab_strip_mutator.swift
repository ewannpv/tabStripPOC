//
//  tab_strip_mutator.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import Foundation

/// Protocol that the tabstrip UI uses to update the model.
protocol TabStripMutator {
    
    /// Tells the receiver to insert a new item in the tabstrip.
    func addNewItem(item:TabStripItem)
    
    /// Tells the receiver to activate the `item`.
    func activateItem(item: TabStripItem)
    
    /// Tells the receiver to close the `item`.
    func closeItem(_ item: TabStripItem)
    
    /// Tells the receiver to move the `item` at the given `destinationIndex`.
    func moveItem(_ item: TabStripItem, destinationIndex: Int)
  
  func groupItem(_ item: TabStripItem)

}

