//
//  BirthdayScreenViewController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit

protocol BirthdayScreenView: AnyObject {
    func updateView(with childData: ChildData)
}

// MARK: -

final class BirthdayScreenViewController: BaseViewController {

    enum Constants {
        static let offset: CGFloat = 16
        static let doubleOffset: CGFloat = offset * 2
        static let tripleOffset: CGFloat = offset * 3
        static let imageSize: CGFloat = 240
    }

    private let controller: BirthdayScreenControlling

    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!

    init(controller: BirthdayScreenControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Birthday Screen"
        controller.viewDidLoad()
    }

    private func setupUI(childData: ChildData) {

        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        let nameLabel = UILabel()
        nameLabel.text = "Name: \(childData.name)"
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)

        view.addSubview(nameLabel)
        nameLabel.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == view.topAnchor + (Constants.doubleOffset + UIApplication.topSafeArea)
        }

        let ageLabel = UILabel()
        ageLabel.text = "Age: \(childData.ageInMonths)"
        ageLabel.numberOfLines = 0
        ageLabel.font = .systemFont(ofSize: 20, weight: .bold)

        view.addSubview(ageLabel)
        ageLabel.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == nameLabel.bottomAnchor + Constants.offset
        }

        photoImageView = ViewFactory.makePhotoImageView(
            image: childData.image,
            upperView: ageLabel,
            parentView: view,
            size: Constants.imageSize,
            upperOffset: Constants.tripleOffset
        )
    }
}

// MARK: - BirthdayScreenView

extension BirthdayScreenViewController: BirthdayScreenView {

    func updateView(with childData: ChildData) {
        setupUI(childData: childData)
    }
}
