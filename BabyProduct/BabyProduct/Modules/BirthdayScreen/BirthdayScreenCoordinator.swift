//
//  BirthdayScreenCoordinator.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol BirthdayScreenCoordinating: AnyObject {
}

// MARK: -

final class BirthdayScreenCoordinator {

    weak var viewController: UIViewController?
}

// MARK: - BirthdayScreenCoordinating

extension BirthdayScreenCoordinator: BirthdayScreenCoordinating {
}
