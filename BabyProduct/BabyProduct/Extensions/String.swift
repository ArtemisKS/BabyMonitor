//
//  String.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 28.06.2021.
//

import Foundation

extension String {

    var trimmed: Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
