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
}

// MARK: -

final class HomeController {

    private let coordinator: HomeCoordinating

    weak var view: HomeView?
    weak var delegate: HomeDelegate?

    init(coordinator: HomeCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - HomeControlling

extension HomeController: HomeControlling {
}
