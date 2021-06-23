//
//  UIApplication.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//
import UIKit

extension UIApplication {

    class var safeAreaInsets: UIEdgeInsets? {
        shared.windows.first?.safeAreaInsets
    }

    class var bottomSafeArea: CGFloat {
        safeAreaInsets?.bottom ?? 0
    }

    class var topSafeArea: CGFloat {
        safeAreaInsets?.top ?? 0
    }
}
