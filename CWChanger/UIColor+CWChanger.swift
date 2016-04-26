//
//  UIColor+CWChanger.swift
//  CWChanger
//
//  Created by hirauchi.shinichi on 2016/04/22.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit

extension UIColor {

    class var cwApplicationThemeColor: UIColor {
        return colorWithHex(red: 0x00, green: 0x66, blue: 0x00, alpha: 1.0)
    }
    class var cwChangerMenuBackgroundColor: UIColor {
        return colorWithHex(red: 0x44, green: 0x44, blue: 0x44, alpha: 1.0)
    }

    class var cwChangerMenuTextColor: UIColor {
        return colorWithHex(red: 0xff, green: 0xff, blue: 0xff, alpha: 1.0)
    }

    private class func colorWithHex(red red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> UIColor {
        let redDegree = CGFloat(red) / 0xff
        let greenDegree = CGFloat(green) / 0xff
        let blueDegree = CGFloat(blue) / 0xff

        return UIColor(red: redDegree, green: greenDegree, blue: blueDegree, alpha: alpha)
    }

}
