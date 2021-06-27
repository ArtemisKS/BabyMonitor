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

final class BirthdayScreenViewController: UIViewController {

    enum Constants {
        static let offset: CGFloat = 16
        static let doubleOffset: CGFloat = offset * 2
        static let tripleOffset: CGFloat = offset * 3
        static let shareButtonWidth: CGFloat = 182
    }

    private let controller: BirthdayScreenControlling

    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!

    private lazy var imageType: String = {
        controller.getRandomColor()
    }()

    private var isModelX: Bool {
        UIApplication.topSafeArea > 20
    }

    init(controller: BirthdayScreenControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        debugPrint("\(String(describing: self)) deinited")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImagePicker()
        addBackButton()
        controller.viewDidLoad()
    }

    private func setupImagePicker() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    private func addBackButton() {
        let backButton = UIButton()
        let image = UIImage(named: "closeIcon")?
            .scalePreservingAspectRatio(
                targetSize: .init(
                    width: Constants.offset,
                    height: Constants.offset
                )
            )
        backButton.setImage(image, for: .normal)
        backButton.frame = .init(origin: .zero, size: CGSize(width: Constants.doubleOffset, height: Constants.doubleOffset))
        backButton.addAction(.init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    }

    private func setupUI(childData: ChildData) {

        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        let screenBounds = UIScreen.main.bounds

        let photoSizeCoef: CGFloat = isModelX ? 1.59 : 1.73
        let photoOffsetCoef: CGFloat = isModelX ? 6.6 : 5.02
        let photoSize = screenBounds.width / photoSizeCoef
        let photoOffset = screenBounds.height / photoOffsetCoef

        photoImageView = ViewFactory.makePhotoImageView(
            image: childData.image,
            upperView: view,
            parentView: view,
            size: photoSize,
            offset: photoOffset
        )

        let backgroundImageView = UIImageView(image: getBackgroundImage())
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.layout { (builder) in
            builder.top == view.topAnchor
            builder.trailing == view.trailingAnchor
            builder.bottom == view.bottomAnchor
            builder.leading == view.leadingAnchor
        }

        let cameraButton = UIButton(type: .system)
        cameraButton.setImage(
            getCameraImage()?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        cameraButton.imageView?.contentMode = .scaleAspectFill
        view.addSubview(cameraButton)
        let photoRadius = photoSize / 2
        let offset = photoRadius - (sqrt(2) / 2) * photoRadius - 1.5
        cameraButton.layout { (builder) in
            builder.width == Constants.doubleOffset
            builder.height == Constants.doubleOffset
            builder.centerY == photoImageView.topAnchor + offset
            builder.centerX == photoImageView.trailingAnchor - offset
        }
        cameraButton.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)

        let nameLabel = UILabel()
        nameLabel.text = "Today \(childData.name) is".uppercased()
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        nameLabel.textColor = .customBlack
        nameLabel.textAlignment = .center

        let actualAge = makeAge(from: childData.ageInMonths)
        let numberImageView = UIImageView(image: UIImage(named: "\(actualAge)icon"))
        numberImageView.contentMode = .scaleAspectFit

        let numberImageSize: CGFloat = isModelX ? 132 : 104
        let swirlImageSize: CGFloat = isModelX ? 62 : 50

        numberImageView.layout { (builder) in
            builder.height == (
                actualAge < 10 ?
                    numberImageSize :
                    numberImageSize / 1.35
            )
            builder.width == (
                actualAge < 10 ?
                    numberImageSize / 1.35 :
                    numberImageSize
            )
        }

        let leftSwirlImageView = UIImageView(image: UIImage(named: "leftSwirl"))
        leftSwirlImageView.contentMode = .scaleAspectFit
        leftSwirlImageView.layout { (builder) in
            builder.width == swirlImageSize
        }

        let rightSwirlImageView = UIImageView(image: UIImage(named: "rightSwirl"))
        rightSwirlImageView.contentMode = .scaleAspectFit
        rightSwirlImageView.layout { (builder) in
            builder.width == swirlImageSize
        }

        let imagesStackView = UIStackView(arrangedSubviews: [leftSwirlImageView, numberImageView, rightSwirlImageView])
        imagesStackView.axis = .horizontal
        imagesStackView.spacing = Constants.offset

        let lowerLabel = UILabel()
        lowerLabel.text = makeAgeText(
            olderThanYear: actualAge != childData.ageInMonths,
            age: actualAge
        ).uppercased()
        lowerLabel.numberOfLines = 0
        lowerLabel.textColor = .customBlack
        lowerLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        lowerLabel.textAlignment = .center

        let upperStackView = UIStackView(arrangedSubviews: [nameLabel, imagesStackView, lowerLabel])
        upperStackView.axis = .vertical
        upperStackView.spacing = Constants.offset / 2

        view.addSubview(upperStackView)
        upperStackView.layout { (builder) in
            builder.centerX == view.centerXAnchor
        }

        let shareImageView = UIImageView(image: UIImage(named: "shareArrowIcon"))
        shareImageView.contentMode = .scaleAspectFit

        shareImageView.layout { (builder) in
            builder.width == Constants.offset * 1.5
        }

        let shareLabel = UILabel()
        shareLabel.text = "Share the news"
        shareLabel.textColor = .customRed
        shareLabel.font = .systemFont(ofSize: 18)

        let shareStackView = UIStackView(arrangedSubviews: [shareLabel, shareImageView])
        shareStackView.spacing = Constants.offset / 2.5
        shareStackView.axis = .horizontal

        let shareBackImageView = UIImageView(image: UIImage(named: "shareButtonBack"))
        shareBackImageView.contentMode = .scaleAspectFit
        shareBackImageView.isUserInteractionEnabled = false

        let shareBackView = UIView()
        shareBackView.isUserInteractionEnabled = false
        for subview in [shareBackImageView, shareStackView] {
            shareBackView.addSubview(subview)
        }

        shareBackImageView.layout { (builder) in
            builder.width == Constants.shareButtonWidth
            builder.height == Constants.tripleOffset
        }

        shareBackView.layout { (builder) in
            builder.leading == shareBackImageView.leadingAnchor
            builder.top == shareBackImageView.topAnchor
            builder.trailing == shareBackImageView.trailingAnchor
            builder.bottom == shareBackImageView.bottomAnchor
        }

        shareStackView.layout { (builder) in
            builder.leading == shareBackView.leadingAnchor + Constants.offset
            builder.top == shareBackView.topAnchor
            builder.bottom == shareBackView.bottomAnchor - Constants.offset / 4
        }

        let shareButton = UIButton(type: .custom)
        shareButton.addSubview(shareBackView)

        view.addSubview(shareButton)
        let shareVerticalOffset = isModelX ?
            Constants.doubleOffset : Constants.offset
        shareButton.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.leading == shareBackView.leadingAnchor
            builder.top == shareBackView.topAnchor
            builder.trailing == shareBackView.trailingAnchor
            builder.bottom == shareBackView.bottomAnchor
            builder.bottom == photoImageView.topAnchor - shareVerticalOffset * 1.5
            builder.top == upperStackView.bottomAnchor + shareVerticalOffset
        }

        shareButton.addAction(.init(handler: { [weak self] _ in
            self?.shareImage()
        }), for: .touchUpInside)

    }

    @objc private func presentImagePicker() {
        imagePicker.present(from: view)
    }

    private func makeAge(from ageInMonths: Int) -> Int {
        let yearInMonths = 12
        return ageInMonths >= yearInMonths ?
            ageInMonths / yearInMonths : ageInMonths
    }

    private func makeAgeText(olderThanYear: Bool, age: Int) -> String {
        var res = olderThanYear ? "year" : "month"
        if age > 1 {
            res += "s"
        }
        return "\(res) old!"
    }

    private func getBackgroundImage() -> UIImage? {
        let suffix = isModelX ? "X" : ""
        return UIImage(named: "\(imageType)Background\(suffix)")
    }

    private func getCameraImage() -> UIImage? {
        UIImage(named: "\(imageType)Camera")
    }

    private func shareImage() {
        guard let image = photoImageView.image, controller.didPickPhoto else {
            view.makeToast("You've got no photo to share", duration: 1.5)
            return
        }

        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            var style = ToastStyle()
            if let error = error {
                style.backgroundColor = .primaryRed
                self.view.makeToast(
                    error.localizedDescription,
                    duration: 2,
                    title: "Error occured",
                    style: style
                )
            } else if !completed {
                return
            }
            style.backgroundColor = .systemGreen
            self.view.makeToast(
                "Image shared successfully",
                duration: 2,
                style: style
            )
        }

        present(activityViewController, animated: true)
    }
}

// MARK: - BirthdayScreenView

extension BirthdayScreenViewController: BirthdayScreenView {

    func updateView(with childData: ChildData) {
        setupUI(childData: childData)
    }
}

extension BirthdayScreenViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        photoImageView.image = image
        if let image = image {
            controller.didPickPhoto(image)
        }
    }
}
