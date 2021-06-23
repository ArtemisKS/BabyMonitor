//
//  HomeCoordinator.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeCoordinating: AnyObject {
}

// MARK: -

final class HomeCoordinator {

    weak var viewController: UIViewController?
}

// MARK: - HomeCoordinating

extension HomeCoordinator: HomeCoordinating {
}
