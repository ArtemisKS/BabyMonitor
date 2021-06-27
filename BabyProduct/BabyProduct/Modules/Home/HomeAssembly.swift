//
//  HomeAssembly.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeAssembling {

    func makeHome() -> UIViewController
}

// MARK: -

final class HomeAssembly {

    private let birthdayScreenAssembly: BirthdayScreenAssembling
    private let childDataStoring: ChildDataStoring
    private let colorRandomizer: ColorRandomizer

    init(
        birthdayScreenAssembly: BirthdayScreenAssembling,
        childDataStoring: ChildDataStoring,
        colorRandomizer: ColorRandomizer
    ) {
        self.birthdayScreenAssembly = birthdayScreenAssembly
        self.childDataStoring = childDataStoring
        self.colorRandomizer = colorRandomizer
    }

}

// MARK: - HomeAssembling

extension HomeAssembly: HomeAssembling {

    func makeHome() -> UIViewController {
        let coordinator = HomeCoordinator(makeBirthdayScreen: birthdayScreenAssembly.makeBirthdayScreen)
        let controller = HomeController(
            coordinator: coordinator,
            childDataStoring: childDataStoring,
            colorRandomizer: colorRandomizer
        )
        let viewController = HomeViewController(controller: controller)
        controller.view = viewController
        coordinator.viewController = viewController
        return viewController
    }
}
