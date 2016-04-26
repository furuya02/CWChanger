//
//  DataManager.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/25.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import Foundation

public class DataManager {

    private var _messages: [String] = []
    private var _name = ""
    private var _sortEnable = true // 最後に使用したメッセージを最上位に移動する
    private var _displayWebView = false
    private var _agreement = ""



    private let userDefault = NSUserDefaults.standardUserDefaults()

    private let MessagesKey = "UserDefaultsMessagesKey"
    private let NameKey = "UserDefaultsNameKey"
    private let SortEnableKey = "UserDefaultsSortEnableKey"
    private let DisplayWebViewKey = "UserDefaultsDisplayWebViewKey"
    private let AgreementKey = "AgreementKey"

    internal init() {

        if let messages = userDefault.objectForKey(MessagesKey) as! [String]? {
            _messages = messages
        }
        if let name = userDefault.objectForKey(NameKey) as! String? {
            _name = name
        }
        if let sortEnable = userDefault.objectForKey(SortEnableKey) as! Bool? {
            _sortEnable = sortEnable
        }
        if let displayWebView = userDefault.objectForKey(DisplayWebViewKey) as! Bool? {
            _displayWebView = displayWebView
        }
        if let agreement = userDefault.objectForKey(AgreementKey) as! String? {
            _agreement = agreement
        }
    }

    internal class var sharedInstance: DataManager {
        struct Static {
            static var onceTaken: dispatch_once_t = 0
            static var instance: DataManager? = nil
        }
        dispatch_once(&Static.onceTaken) {
            Static.instance = DataManager()
        }
        return Static.instance!
    }

    internal var messages: [String] {
        get {
            return _messages
        }
    }

    internal var sortEnable: Bool {
        get {
            return _sortEnable
        }
        set {
            _sortEnable = newValue
            userDefault.setBool(newValue, forKey: SortEnableKey)
            userDefault.synchronize()
        }
    }

    internal var displayWebView: Bool {
        get {
            return _displayWebView
        }
        set {
            _displayWebView = newValue
            userDefault.setBool(newValue, forKey: DisplayWebViewKey)
            userDefault.synchronize()
        }
    }

    internal var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
            userDefault.setObject(newValue, forKey: NameKey)
            userDefault.synchronize()
        }
    }

    internal var agreement: String {
        get {
            return _agreement
        }
        set {
            _agreement = newValue
            userDefault.setObject(newValue, forKey: AgreementKey)
            userDefault.synchronize()
        }
    }


    internal var url: String {
        get {
            return (agreement == "") ? "https://www.chatwork.com/" : "https://kcw.kddi.ne.jp/s/\(_agreement)/"
        }
    }
    internal var logoutUrl: String {
        get {
            return (agreement == "") ? "https://www.chatwork.com/?act=logout" : "https://kcw.kddi.ne.jp/s/\(_agreement)/?act=logout"
        }
    }

    internal func chatworkName(index: Int) -> String {
        if 0 <= index && index < _messages.count {
            return "\(_name)@\(_messages[index])"
        }
        return _name
    }


    internal func setChatworkName(chatworkName: String) {
        if let range = chatworkName.rangeOfString("@") {
            let message = chatworkName.substringFromIndex(range.startIndex.advancedBy(1))
            add(message)
            name = chatworkName.substringToIndex(range.startIndex)
        }else {
            name = chatworkName
        }
    }


    // メッセージの編集（順番は変わらない）
    internal func edit(fromMessage: String, toMessage: String) {
        if let index = _messages.indexOf(fromMessage) {
            _messages[index] = toMessage
            saveMessages()
        }
    }

    // メッセージの削除
    internal func remove(message: String) {
        if let index = _messages.indexOf(message) {
            _messages.removeAtIndex(index)
            saveMessages()
        }
    }

    // メッセージを使用すると一番上に追加される（同じメッセージは削除される）
    internal func add(message: String) {
        remove(message)
        _messages.insert(message, atIndex: 0)
        saveMessages()
    }


    private func saveMessages() {
        userDefault.setObject(_messages, forKey: MessagesKey)
        userDefault.synchronize()
    }

}
