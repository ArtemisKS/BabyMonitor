//
//  HomeController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeDelegate: AnyObject {
}

// MARK: -

protocol HomeInput: AnyObject {

    var delegate: HomeDelegate? { get set }
}

// MARK: -

protocol HomeControlling: HomeInput {
    func viewDidReceiveTapOnBirthdayScreenButton(childData: ChildData, didPickPhoto: Bool)
    func getRandomColor() -> String
    func getPhoto() -> UIImage?
    func getChildCredentials() -> ChildCredentials?
    func didPickPhoto(_ photo: UIImage)
}

// MARK: -

final class HomeController {

    private let coordinator: HomeCoordinating
    private let childDataStoring: ChildDataStoring
    private let colorRandomizer: ColorRandomizer

    weak var view: HomeView?
    weak var delegate: HomeDelegate?

    init(
        coordinator: HomeCoordinating,
        childDataStoring: ChildDataStoring,
        colorRandomizer: ColorRandomizer
    ) {
        self.coordinator = coordinator
        self.childDataStoring = childDataStoring
        self.colorRandomizer = colorRandomizer
    }
}

// MARK: - HomeControlling

extension HomeController: HomeControlling {

    func viewDidReceiveTapOnBirthdayScreenButton(childData: ChildData, didPickPhoto: Bool) {
        childDataStoring.childCredentials = childData.childCreds
        if didPickPhoto {
            childDataStoring.childPhoto = childData.image
        }
        coordinator.openBirthdayScreen(childData: childData, delegate: self)
    }

    func getRandomColor() -> String {
        colorRandomizer.makeImageColor()
    }

    func getPhoto() -> UIImage? {
        childDataStoring.childPhoto
    }

    func getChildCredentials() -> ChildCredentials? {
        childDataStoring.childCredentials
    }

    func didPickPhoto(_ photo: UIImage) {
        childDataStoring.childPhoto = photo
    }
}

// MARK: -

extension HomeController: BirthdayScreenDelegate {

    func updatePhoto(_ photo: UIImage) {
        view?.updatePhoto(photo)
    }
}
