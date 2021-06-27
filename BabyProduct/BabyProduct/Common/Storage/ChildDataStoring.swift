//
//  ChildDataStoring.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 27.06.2021.
//

import UIKit

protocol ChildDataStoring: AnyObject {

    var didStoreChildPhoto: Bool { get }
    var childCredentials: ChildCredentials? { get set }
    var childPhoto: UIImage? { get set }
}
