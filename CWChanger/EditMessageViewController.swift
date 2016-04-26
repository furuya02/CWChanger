//
//  EditMessageViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/23.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class EditMessageViewController: UIViewController {

    internal var index = 0

    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        if index == -1 {
            titleLabel.text = NSLocalizedString("CWAdd", comment: "")
        }else {
            titleLabel.text = NSLocalizedString("CWEdit", comment: "")
            messageTextField.text = DataManager.sharedInstance.messages[index]
        }
        messageTextField.becomeFirstResponder()
    }

    @IBAction func tapCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func tapOkButton(sender: AnyObject) {

        if messageTextField.text != "" {
            let dataManager = DataManager.sharedInstance
            if index != -1 {
                dataManager.edit(dataManager.messages[index],toMessage: messageTextField.text!)
            }else {
                dataManager.add(messageTextField.text!)
            }

            NSNotificationCenter.defaultCenter()
                .postNotificationName(CWChangeDataNotificationKey, object: nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}
