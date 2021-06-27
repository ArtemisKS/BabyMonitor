//
//  BirthdayScreenController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol BirthdayScreenDelegate: AnyObject {
    func updatePhoto(_ photo: UIImage)
}

// MARK: -

protocol BirthdayScreenInput: AnyObject {

    var delegate: BirthdayScreenDelegate? { get set }
}

// MARK: -

protocol BirthdayScreenControlling: BirthdayScreenInput {
    var didPickPhoto: Bool { get }
    func viewDidLoad()
    func getRandomColor() -> String
    func didPickPhoto(_ photo: UIImage)
}

// MARK: -

final class BirthdayScreenController {

    private let coordinator: BirthdayScreenCoordinating
    private let childData: ChildData
    private let childDataStoring: ChildDataStoring
    private let colorRandomizer: ColorRandomizer

    weak var view: BirthdayScreenView?
    weak var delegate: BirthdayScreenDelegate?

    init(
        coordinator: BirthdayScreenCoordinating,
        childData: ChildData,
        childDataStoring: ChildDataStoring,
        colorRandomizer: ColorRandomizer
    ) {
        self.coordinator = coordinator
        self.childData = childData
        self.childDataStoring = childDataStoring
        self.colorRandomizer = colorRandomizer
    }
}

// MARK: - BirthdayScreenControlling

extension BirthdayScreenController: BirthdayScreenControlling {

    var didPickPhoto: Bool {
        childDataStoring.didStoreChildPhoto
    }

    func viewDidLoad() {
        view?.updateView(with: childData)
    }

    func getRandomColor() -> String {
        colorRandomizer.makeImageColor()
    }

    func didPickPhoto(_ photo: UIImage) {
        childDataStoring.childPhoto = photo
        delegate?.updatePhoto(photo)
    }
}
