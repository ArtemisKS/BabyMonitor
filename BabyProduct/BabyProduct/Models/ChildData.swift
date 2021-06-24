//
//  ChildData.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

class ChildData {

    let name: String
    let ageInMonths: Int
    let image: UIImage?

    init(name: String, ageInMonths: Int, image: UIImage?) {
        self.name = name
        self.ageInMonths = ageInMonths
        self.image = image
    }
}
