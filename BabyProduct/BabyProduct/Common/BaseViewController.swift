//
//  BaseViewController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        navigationItem.backButtonTitle = ""

        view.backgroundColor = .background
    }
}
