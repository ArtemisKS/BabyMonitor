//
//  HomeCoordinator.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeCoordinating: AnyObject {
    func openBirthdayScreen(childData: ChildData, delegate: BirthdayScreenDelegate?)
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

    func openBirthdayScreen(childData: ChildData, delegate: BirthdayScreenDelegate?) {
        let module = makeBirthdayScreen(childData)
        module.input.delegate = delegate
        let navigationController = UINavigationController(rootViewController: module.viewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }
}
