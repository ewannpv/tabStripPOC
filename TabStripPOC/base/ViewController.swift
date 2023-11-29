//
//  ViewController.swift
//  TabStripPOC
//
//  Created by Ewann Pellé on 22/11/2023.
//

import UIKit

class ViewController: UIViewController {
    private var tabStripMediator: TabStripMediator = TabStripMediator()
    private var tabStripController:TabStripViewController = TabStripViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabStripMediator.consumer = tabStripController
        tabStripController.mutator = tabStripMediator

        var frame : CGRect = tabStripController.view.frame
        frame.origin.y += 20
        frame.size.height = TabStripConstants.height
        tabStripController.view.frame = frame
        
        view.addSubview(tabStripController.view!)
    }
}

