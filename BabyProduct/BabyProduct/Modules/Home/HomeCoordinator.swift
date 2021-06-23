//
//  HomeCoordinator.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeCoordinating: AnyObject {
    func openBirthdayScreen(childData: ChildData)
}

// MARK: -

final class HomeCoordinator {

    private let makeBirthdayScreen: (ChildData) -> AssembledModule<BirthdayScreenInput>

    weak var viewController: UIViewController?

    init(makeBirthdayScreen: @escaping (ChildData) -> AssembledModule<BirthdayScreenInput>) {
        self.makeBirthdayScreen = makeBirthdayScreen
    }
}

// MARK: - HomeCoordinating

extension HomeCoordinator: HomeCoordinating {

    func openBirthdayScreen(childData: ChildData) {
        let module = makeBirthdayScreen(childData)
        let navigationController = UINavigationController(rootViewController: module.viewController)
        viewController?.present(navigationController, animated: true)
    }
}
