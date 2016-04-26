//
//  MenuViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/21.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataManager = DataManager.sharedInstance

    let menu: [[String]] = [
        [NSLocalizedString("CWMenuHome", comment: ""),"menuicon-home"],
        [NSLocalizedString("CWMenuSetting", comment: ""),"menuicon-setting"],
        [NSLocalizedString("CWMenuLogout", comment: ""),"menuicon-logout"]]


    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.cwChangerMenuBackgroundColor
        cell.textLabel?.textColor = UIColor.cwChangerMenuTextColor
    }

    override func viewDidLoad() {
        tableView.rowHeight = 50
        tableView.separatorStyle = .None
    }


}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = menu[indexPath.row][0]
        cell.imageView!.image = UIImage(named: menu[indexPath.row][1])
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)


        if indexPath.row == 0 {
            sidePanelController.showCenterPanelAnimated(true)
        }

        if indexPath.row == 1 {


            if let settingView = self.storyboard?.instantiateViewController(SettingNavigationController) {
                self.presentViewController(settingView as UIViewController, animated: true, completion: nil)
            }
        }

        if indexPath.row == 2 {
            ExWebView.sharedInstance.loadRequest(NSURLRequest(URL: NSURL(string: dataManager.logoutUrl)!))
        }

    }

}
