//
//  ValidatorService.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 28.06.2021.
//

import Foundation

enum ValidatorService {

    private enum Const {
        static let maxNameLen = 30
    }

    static func validateName(text: String, newText: String) -> Bool {
        let hasCorrectPattern =
            !newText.trimmed.isEmpty
            && newText != text
            && !(newText.last?.isWhitespace == true
                    && text.last?.isWhitespace == true)
            && newText.allSatisfy { $0.isLetter || $0.isWhitespace }
            && newText.count <= Const.maxNameLen
        let shouldChange =
            newText.isEmpty
            || newText.count < text.count
            || hasCorrectPattern
        return shouldChange
    }
}
