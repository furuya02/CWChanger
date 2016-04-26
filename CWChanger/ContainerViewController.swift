//
//  ViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/24.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import JASidePanels

class ContainerViewController: JASidePanelController {

    override func awakeFromNib() {
        centerPanel = self.storyboard?.instantiateViewController(MainViewController)
        leftPanel = self.storyboard?.instantiateViewController(MenuViewController)
    }

}

// MARK: - JASidePanel
extension ContainerViewController {

    override func stylePanel(panel: UIView!) {
    }

}
