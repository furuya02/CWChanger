//
//  ExWebView.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/25.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class ExWebView: UIWebView {

    var script = ""

    func callJs(js: String) -> String {
        return self.stringByEvaluatingJavaScriptFromString(js)!
    }

    internal class var sharedInstance: ExWebView {
        struct Static {
            static var onceTaken: dispatch_once_t = 0
            static var instance: ExWebView? = nil
        }
        dispatch_once(&Static.onceTaken) {
            Static.instance = ExWebView()
        }
        return Static.instance!
    }

    var html: String {
        get {
            return callJs("document.body.innerHTML")
        }
    }
    var title: String {
        get {
            return callJs("document.title")
        }
    }
    var url: String {
        get {
            return callJs("document.URL")
        }
    }


    func setValueByName(name: String, n: Int, value: String) {
        append("var elements = document.getElementsByName('\(name)');elements[\(n)].value = '\(value)';")

    }

    func setValueById(id: String, value: String) {
        append("var element = document.getElementById('\(id)');element.value = '\(value)';")
    }

    func clickByName(name: String, n: Int) -> String {
        append ("document.getElementsByName('\(name)')[\(n)].click();")
        return exec()
    }

    func clickById(id: String) -> String {
        append ("document.getElementById('\(id)').click();")
        return exec()
    }

    func clickByClassname(classname: String, n: Int) -> String {
        append("document.getElementsByClassName('\(classname)')[\(n)].click();")
        return exec()
    }

    func clickByAriaLabel(ariaLabel: String) -> String {
        append("document.querySelector('[aria-label=\"\(ariaLabel)\"]').click();")
        return exec()
    }

    func getAriaLabelById(id: String) -> String {
        append("document.getElementById('\(id)').getAttribute('aria-label')")
        return exec()
    }


    private func append(str: String) {
        script = script + str
    }

    func exec() -> String {
        let result = callJs(script)
        script = ""
        return result

    }

}
