//
//  ChildData.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

struct ChildCredentials: Codable {
    let name: String
    let ageInMonths: Int
}

class ChildData {

    let childCreds: ChildCredentials
    let image: UIImage?

    var name: String {
        childCreds.name
    }

    var ageInMonths: Int {
        childCreds.ageInMonths
    }

    init(
        name: String,
        ageInMonths: Int,
        image: UIImage?
    ) {
        self.childCreds = .init(name: name, ageInMonths: ageInMonths)
        self.image = image
    }

    convenience init(childCreds: ChildCredentials, image: UIImage?) {
        self.init(
            name: childCreds.name,
            ageInMonths: childCreds.ageInMonths,
            image: image
        )
    }
}
