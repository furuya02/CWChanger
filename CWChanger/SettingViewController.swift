//
//  SettingViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/22.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var agreementTextField: UITextField!
    var dataManager = DataManager.sharedInstance

    override func viewDidLoad() {
        nameTextField.text = dataManager.name
        agreementTextField.text = dataManager.agreement
    }

    @IBAction func tapOkButton(sender: AnyObject) {

        dataManager.name = nameTextField.text!
        dataManager.agreement = agreementTextField.text!
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func tapCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }



}
