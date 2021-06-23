//
//  HomeAssembly.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeAssembling {

    func makeHome() -> AssembledModule<HomeInput>
}

// MARK: -

final class HomeAssembly {
}

// MARK: - HomeAssembling

extension HomeAssembly: HomeAssembling {

    func makeHome() -> AssembledModule<HomeInput> {
        let coordinator = HomeCoordinator()
        let controller = HomeController(coordinator: coordinator)
        let viewController = HomeViewController(controller: controller)
        controller.view = viewController
        coordinator.viewController = viewController
        return .init(
            viewController: viewController,
            input: controller
        )
    }
}
