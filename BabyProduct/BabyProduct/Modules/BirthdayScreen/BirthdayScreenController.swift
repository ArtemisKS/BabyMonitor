//
//  BirthdayScreenController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import Foundation

protocol BirthdayScreenDelegate: AnyObject {
}

// MARK: -

protocol BirthdayScreenInput: AnyObject {

    var delegate: BirthdayScreenDelegate? { get set }
}

// MARK: -

protocol BirthdayScreenControlling: BirthdayScreenInput {
    func viewDidLoad()
}

// MARK: -

final class BirthdayScreenController {

    private let coordinator: BirthdayScreenCoordinating
    private let childData: ChildData

    weak var view: BirthdayScreenView?
    weak var delegate: BirthdayScreenDelegate?

    init(
        coordinator: BirthdayScreenCoordinating,
        childData: ChildData
    ) {
        self.coordinator = coordinator
        self.childData = childData
    }
}

// MARK: - BirthdayScreenControlling

extension BirthdayScreenController: BirthdayScreenControlling {

    func viewDidLoad() {
        view?.updateView(with: childData)
    }
}
