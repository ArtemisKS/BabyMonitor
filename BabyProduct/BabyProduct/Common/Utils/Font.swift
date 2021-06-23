//
//  Font.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

enum Font {
    static let title = ProximaNova.font(of: 28, type: .bold)
    static let subTitle = ProximaNova.font(of: 18, type: .regular)
    static let subTitleMedium = ProximaNova.font(of: 18, type: .medium)
    static let textTitle = ProximaNova.font(of: 15, type: .regular)
    static let smallTitle = ProximaNova.font(of: 13, type: .regular)
    static let textTitleBold = ProximaNova.font(of: 15, type: .bold)
    static let textSubtitle = ProximaNova.font(of: 16, type: .regular)
    static let textSubtitleBold = ProximaNova.font(of: 16, type: .bold)
    static let locationDigit = ProximaNova.font(of: 26, type: .bold)
    static let buttonTitle = ProximaNova.font(of: 18, type: .bold)
    static let milesCountFont = ProximaNova.font(of: 24, type: .bold)
    static let sessionDateFont = ProximaNova.font(of: 22, type: .bold)
}

private enum FontConstructor {

    static func font(with name: String, of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

private enum ProximaNova {

    enum FontType: String {
        case regular = "ProximaNova-Regular"
        case medium = "ProximaNova-Medium"
        case bold = "ProximaNova-Bold"
    }

    static func font(of size: CGFloat, type: FontType) -> UIFont {
        FontConstructor.font(with: type.rawValue, of: size)
    }
}
