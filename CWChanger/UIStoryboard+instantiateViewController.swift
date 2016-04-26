//
//  UIStoryboard+instantiateViewController.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/26.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

extension UIStoryboard {
    // クラス名と同一のStoryboardIDを持つViewControllerの生成
    public func instantiateViewController<T: UIViewController>(type: T.Type) -> T {
        let className = NSStringFromClass(type.self).componentsSeparatedByString(".").last!
        return instantiateViewControllerWithIdentifier(className) as! T
    }

}
