//
//  MainViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/21.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SCLAlertView
import SVProgressHUD

class MainViewController:UIViewController,UIWebViewDelegate {

    @IBOutlet weak var nameOnlyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    var dataManager = DataManager.sharedInstance
    let webView = ExWebView.sharedInstance

    override func viewDidLoad() {

        tableView.rowHeight = 50
        headerView.backgroundColor = UIColor.cwApplicationThemeColor
        SVProgressHUD.setDefaultAnimationType(.Native)
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.show()

        nameOnlyLabel.text = NSLocalizedString("CWNameOnly", comment: "")

        let userAgentStr = "ChatWork Profile Changer"
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent":userAgentStr])


        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MainViewController.changeData),
            name: CWChangeDataNotificationKey,
            object: nil
        )

        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string : dataManager.url)!))


// Debug
//        let frame = view.frame
//        webView.frame = CGRect(x: 0,y: frame.height-300,width: frame.width,height: frame.height)
//        webView.userInteractionEnabled = false
//        view.addSubview(webView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func changeData(){
        tableView.reloadData()
    }

    @IBAction func tapNameOnlyButton(sender: AnyObject) {
        change(NSLocalizedString("CWNameOnly", comment: ""),chatworkName: dataManager.name)
    }

    @IBAction func tapMenuButton(sender: AnyObject) {
        self.sidePanelController.showLeftPanelAnimated(true)
    }


    @IBAction func tapAddButton(sender: AnyObject) {
        goEditMessageView(-1)
    }

    func goEditMessageView(index:Int){
        if let editMessageView = self.storyboard?.instantiateViewController(EditMessageViewController) {
            editMessageView.index = index
            self.presentViewController(editMessageView, animated: true, completion:nil)
        }
    }

    func webViewDidFinishLoad(w: UIWebView) {
        //let webView = ExWebView.sharedInstance
        let html = webView.html
        let greeatingMessageJapanese = "メールアドレスでログインする"
        let greeatingMessageEnglish = "Log in with email address"


        if html.rangeOfString(greeatingMessageJapanese) != nil || html.rangeOfString(greeatingMessageEnglish) != nil {
            NSNotificationCenter.defaultCenter()
                .postNotificationName(CWLogoutNotificationKey, object: nil)

            if let loginView = self.storyboard?.instantiateViewController(LoginViewController) {
                self.presentViewController(loginView, animated: true, completion:nil)
            }

        }else{
            NSNotificationCenter.defaultCenter()
                .postNotificationName(CWLoginNotificationKey, object: nil)
            self.sidePanelController.showCenterPanelAnimated(true)

            webView.clickById("_myProfile"); // 「プロフィール」をクリック

            let chatworkName = webView.getAriaLabelById("_profileContent")

            if chatworkName != "" && chatworkName.rangeOfString("Loading...") == nil {
                dataManager.setChatworkName(chatworkName)
                nameLabel.text = chatworkName
                SVProgressHUD.dismiss()

                NSNotificationCenter.defaultCenter()
                    .postNotificationName(CWChangeDataNotificationKey, object: nil)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataManager.messages[indexPath.row]
        //cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(24))
        return cell
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: NSLocalizedString("CWEdit", comment: "")) {
            (action, indexPath) in
            self.goEditMessageView(indexPath.row)
        }
        edit.backgroundColor = UIColor.darkGrayColor()

        let del = UITableViewRowAction(style: .Default, title: NSLocalizedString("CWDelete", comment: "")) {
            (action, indexPath) in
            self.dataManager.remove(self.dataManager.messages[indexPath.row])
            self.changeData()
        }

        del.backgroundColor = UIColor.redColor()
        
        return [edit, del]
    }

    func change(message:String,chatworkName:String){
        let alertView = SCLAlertView()
        alertView.showCircularIcon = false
        alertView.showCloseButton = false
        alertView.addButton(NSLocalizedString("CWCancel", comment: "")){}
        alertView.addButton(NSLocalizedString("CWOk", comment: "")){
            self.dispatch_async_main {
                let saveButton = "保存する"
                self.webView.clickByClassname("_profileEdit",n: 0);//「プロフィールを編集」をクリック
                NSThread.sleepForTimeInterval(0.5)
                self.webView.setValueById("_profileInputName",value: chatworkName); // 名前を入力
                self.webView.clickByAriaLabel(saveButton)// 「保存する」をクリック
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string : self.dataManager.url)!))
            }

            if message != NSLocalizedString("CWNameOnly", comment: "") {
                self.dataManager.add(message)
            }
            self.changeData()

            SVProgressHUD.show()
        }
        alertView.showInfo(message, subTitle: NSLocalizedString("CWConfirmation", comment: ""), closeButtonTitle: nil, duration: 0, colorStyle: 0x006600, colorTextButton: 0xFFFFFF,circleIconImage: nil)
    }

}


// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let message = dataManager.messages[indexPath.row]
        let name = dataManager.name
        let chatworkName = "\(name)@\(message)"

        change(message,chatworkName: chatworkName)
    }
}

