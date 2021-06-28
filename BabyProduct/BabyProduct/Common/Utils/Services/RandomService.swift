//
//  RandomService.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 28.06.2021.
//

import Foundation

protocol ColorRandomizer {
    func makeImageColor() -> String
}

class RandomService: ColorRandomizer {

    enum Color: String, CaseIterable {
        case blue
        case green
        case yellow
    }

    private var counter = -1

    private lazy var imageTypes: [String] = {
        Color.allCases.map(\.rawValue).shuffled()
    }()

    func makeImageColor() -> String {
        let typesCount = imageTypes.count
        let index = (counter + 1) % typesCount
        counter = index
        return imageTypes[index]
    }
}
