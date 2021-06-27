//
//  BirthdayScreenAssembly.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol BirthdayScreenAssembling {

    func makeBirthdayScreen(childData: ChildData) -> AssembledModule<BirthdayScreenInput>
}

// MARK: -

final class BirthdayScreenAssembly {

    private let childDataStoring: ChildDataStoring
    private let colorRandomizer: ColorRandomizer

    init(
        childDataStoring: ChildDataStoring,
        colorRandomizer: ColorRandomizer
    ) {
        self.childDataStoring = childDataStoring
        self.colorRandomizer = colorRandomizer
    }
}

// MARK: - BirthdayScreenAssembling

extension BirthdayScreenAssembly: BirthdayScreenAssembling {

    func makeBirthdayScreen(childData: ChildData) -> AssembledModule<BirthdayScreenInput> {
        let coordinator = BirthdayScreenCoordinator()
        let controller = BirthdayScreenController(
            coordinator: coordinator,
            childData: childData,
            childDataStoring: childDataStoring,
            colorRandomizer: colorRandomizer
        )
        let viewController = BirthdayScreenViewController(controller: controller)
        controller.view = viewController
        coordinator.viewController = viewController
        return .init(
            viewController: viewController,
            input: controller
        )
    }
}
