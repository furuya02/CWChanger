//
//  LoginViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/25.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SCLAlertView
import SVProgressHUD

class LoginViewController: UIViewController{

    @IBOutlet weak var agreementButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var dataManager = DataManager.sharedInstance
    var webView = ExWebView.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.placeholder = NSLocalizedString("CWEmailPlaceholder", comment: "")
        passwordTextField.placeholder = NSLocalizedString("CWPasswordPlaceholder", comment: "")
        loginButton.titleLabel?.text = NSLocalizedString("CWLoginButton", comment: "")
        loginButton.enabled = false
        initAgreementButton()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(LoginViewController.logout),
            name: CWLogoutNotificationKey,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(LoginViewController.login),
            name: CWLoginNotificationKey,
            object: nil
        )
        webView.loadRequest(NSURLRequest(URL: NSURL(string : dataManager.url)!))

    }

    @IBAction func tapAgreementButton(sender: AnyObject) {
        let alertView = SCLAlertView()
        let txt = alertView.addTextField("")
        alertView.showCloseButton = false
        alertView.addButton("OK") {
            self.dataManager.agreement = txt.text!
            self.initAgreementButton()

            self.webView.loadRequest(NSURLRequest(URL: NSURL(string : self.dataManager.url)!))

        }
        alertView.showInfo("契約名", subTitle: "無料プランの場合は、入力の必要はありません",closeButtonTitle: nil, duration: 0, colorStyle: 0x006600, colorTextButton: 0xFFFFFF,circleIconImage: nil)

    }

    func initAgreementButton(){
        var agreementName = dataManager.agreement
        if agreementName == "" {
            agreementName = NSLocalizedString("CWAgreementName", comment: "")
        }
        agreementButton.setTitle(agreementName, forState: .Normal)
    }


    func login(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    func logout(){
        print("logout")
        SVProgressHUD.dismiss()
        loginButton.enabled = true
    }

    @IBAction func tapLoginButton(sender: AnyObject) {
        SVProgressHUD.show()

        webView.setValueByName("email",n: 0,value: emailTextField.text!);
        webView.setValueByName("password",n: 0,value: passwordTextField.text!);
        webView.clickByName("login",n: 1);

    }

}
