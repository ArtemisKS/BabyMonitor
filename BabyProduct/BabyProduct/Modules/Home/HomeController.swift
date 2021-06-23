//
//  HomeController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import Foundation

protocol HomeDelegate: AnyObject {
}

// MARK: -

protocol HomeInput: AnyObject {

    var delegate: HomeDelegate? { get set }
}

// MARK: -

protocol HomeControlling: HomeInput {
    func viewDidReceiveTapOnBirthdayScreenButton(name: String, age: Int)
}

// MARK: -

final class HomeController {

    private let coordinator: HomeCoordinating

    weak var view: HomeView?
    weak var delegate: HomeDelegate?

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }

    func viewDidReceiveTapOnBirthdayScreenButton(name: String, age: Int) {
        coordinator.openBirthdayScreen(
            childData: ChildData(
                name: name,
                ageInMonths: age
            )
        )
    }
}

// MARK: - HomeControlling

extension HomeController: HomeControlling {
}
