//
//  HomeViewController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol HomeView: AnyObject {
}

// MARK: -

final class HomeViewController: BaseViewController {

    private let controller: HomeControlling

    init(controller: HomeControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        let label = UILabel()
        label.text = "Hey, loser!"

        view.addSubview(label)
        label.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.centerY == view.centerYAnchor
        }
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
}
