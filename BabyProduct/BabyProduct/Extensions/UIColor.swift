//
//  UIColor.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

extension UIColor {

    class var background: UIColor {
        return UIColor(red: 22, green: 14, blue: 83)
    }

    class var primary: UIColor {
        UIColor(rgb: 0x605DFF)
    }

    class var grayBackground: UIColor {
        UIColor(rgb: 0xF7F7F7)
    }

    class var grayText: UIColor {
        UIColor(rgb: 0xBDBDBD)
    }

    class var primaryRed: UIColor {
        UIColor(red: 215, green: 46, blue: 71)
    }

    class var customRed: UIColor {
        UIColor(red: 215, green: 129, blue: 127)
    }

    class var customBlack: UIColor {
        UIColor(red: 59, green: 69, blue: 96)
    }

    // MARK: - Custom Initializers

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let threshold = 255

        self.init(
            red: CGFloat(red % threshold) / CGFloat(threshold),
            green: CGFloat(green % threshold) / CGFloat(threshold),
            blue: CGFloat(blue % threshold) / CGFloat(threshold),
            alpha: alpha
        )
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
