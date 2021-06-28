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

    private let controller: BirthdayScreenControlling

    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!
    private let cameraButton = UIButton(type: .system)
    private var shareButton: UIButton!

    private lazy var imageType: String = {
        controller.getRandomColor()
    }()

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
        backButton.frame = .init(
            origin: .zero,
            size: CGSize(
                width: Constants.doubleOffset,
                height: Constants.doubleOffset
            )
        )
        backButton.addAction(.init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    }

    @objc private func presentImagePicker() {
        imagePicker.present(from: view)
    }

    private func shareImage() {
        guard photoImageView.image != nil,
              controller.didPickPhoto else {
            view.makeToast("You've got no photo to share", duration: 1.5)
            return
        }

        func conductShareImage() {
            let viewScreenshot = view.makeScreenshot()

            let imageToShare = [viewScreenshot]
            let activityViewController = UIActivityViewController(
                activityItems: imageToShare,
                applicationActivities: nil
            )
            activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
            activityViewController.completionWithItemsHandler = { (_, completed, _, error) in
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

            present(activityViewController, animated: true) { [weak self] in
                self?.setupScreen(forScreenshot: false)
            }
        }

        setupScreen(forScreenshot: true) {
            conductShareImage()
        }
    }

    private func setupScreen(forScreenshot: Bool, completion: (() -> Void)? = nil) {

        func animation() {
            let alpha: CGFloat = forScreenshot ? 0 : 1
            cameraButton.alpha = alpha
            shareButton.alpha = alpha
        }

        UIView.animate(withDuration: 0.25) {
            animation()
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - UI Setup

private extension BirthdayScreenViewController {

    func setupPhotoImageView(image: UIImage?) -> CGFloat {
        let screenBounds = UIScreen.main.bounds

        let photoSizeCoef: CGFloat = isModelX ? 1.59 : 1.73
        let photoOffsetCoef: CGFloat = isModelX ? 6.6 : 5.02
        let photoSize = screenBounds.width / photoSizeCoef
        let photoOffset = screenBounds.height / photoOffsetCoef

        photoImageView = ViewFactory.makePhotoImageView(
            image: image,
            upperView: view,
            parentView: view,
            size: photoSize,
            offset: photoOffset
        )
        return photoSize
    }

    func setupBackgroundViewImage() {
        let backgroundImageView = UIImageView(image: getBackgroundImage())
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.layout {
            $0.top == view.topAnchor
            $0.trailing == view.trailingAnchor
            $0.bottom == view.bottomAnchor
            $0.leading == view.leadingAnchor
        }
    }

    func setupCameraButton(photoSize: CGFloat) {
        cameraButton.setImage(
            getCameraImage()?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        cameraButton.imageView?.contentMode = .scaleAspectFill
        view.addSubview(cameraButton)
        let photoRadius = photoSize / 2
        let offset = photoRadius - (sqrt(2) / 2) * photoRadius - 1.5
        cameraButton.layout {
            $0.width == Constants.doubleOffset
            $0.height == Constants.doubleOffset
            $0.centerY == photoImageView.topAnchor + offset
            $0.centerX == photoImageView.trailingAnchor - offset
        }
        cameraButton.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
    }

    func makeUpperStackView(childData: ChildData) -> UIStackView {

        ViewFactory.makeUpperStackView(
            childData: childData,
            parentView: view,
            isModelX: isModelX,
            makeAge: makeAge(from:),
            makeAgeText: makeAgeText(olderThanYear:age:)
        )
    }

    func setupShareButton(upperView: UIView) {
        shareButton = ViewFactory.makeShareButton(
            parentView: view,
            upperView: upperView,
            lowerView: photoImageView,
            isModelX: isModelX)
        shareButton.addAction(.init(handler: { [weak self] _ in
            self?.shareImage()
        }), for: .touchUpInside)
    }

    func setupUI(childData: ChildData) {

        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        let photoSize = setupPhotoImageView(image: childData.image)

        setupBackgroundViewImage()

        setupCameraButton(photoSize: photoSize)

        let upperStackView = makeUpperStackView(childData: childData)

        setupShareButton(upperView: upperStackView)
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
