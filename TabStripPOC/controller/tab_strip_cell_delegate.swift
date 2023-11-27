//
//  tab_strip_cell_delegate.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

// Informs the receiver of actions on the cell.
protocol TabStripCellDelegate {
    // Informs the receiver that the close button on the cell was tapped.
    func closeButtonTappedFor(cell: TabStripCell?)
}
