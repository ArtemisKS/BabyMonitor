//
//  HomeViewController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//  
//

import UIKit
import Combine

protocol HomeView: AnyObject {
}

// MARK: -

final class HomeViewController: BaseViewController {

    private enum Constants {
        static let offset: CGFloat = 16
        static let doubleOffset: CGFloat = offset * 2
        static let tripleOffset: CGFloat = offset * 3
        static let imageSize: CGFloat = 240
        static let buttonHeight: CGFloat = 48
        static let datePickerWidth: CGFloat = 280
        static let secInDay: TimeInterval = 60 * 60 * 24
        static let secInMon: TimeInterval = secInDay * 30
        static let secInYear: TimeInterval = secInMon * 12
        static let secInMaxAgeYears: TimeInterval = secInYear * Double(maxAgeYears)
        static let maxAgeYears = 12
        static let minAgeMonths = 1 // 1 month min age
        static let maxAgeMonths = 12 * maxAgeYears // 12 years max age
        static let maxNameLen = 30
    }

    private let controller: HomeControlling

    private let showBirthdayScreenButton = ActionButton()
    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!

    private var didPickImage = false

    @Published private var name = "Хуй"
    @Published private var ageInMonths = 10

    private var cancellable: AnyCancellable?
    
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($name, $ageInMonths)
            .map { name, age in
                !name.isEmpty &&
                    age >= Constants.minAgeMonths && age <= Constants.maxAgeMonths
            }.eraseToAnyPublisher()
    }
    
    init(controller: HomeControlling) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startAvoidingKeyboard()
        setupImagePicker()
        setupUI()
        subscribeOnButtonUpdates()
    }

    deinit {
        stopAvoidingKeyboard()
    }

    private func setupImagePicker() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    private func subscribeOnButtonUpdates() {
        cancellable = validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.buttonIsEnabled, on: showBirthdayScreenButton)
    }
}

// UI setup
private extension HomeViewController {

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Baby monitor"
        label.font = .systemFont(ofSize: 25, weight: .bold)

        view.addSubview(label)
        label.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == view.topAnchor + (Constants.offset + UIApplication.topSafeArea)
        }
        return label
    }

    func makeTextField(upperView: UIView) -> UITextField {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"
        nameTextField.textAlignment = .center

        view.addSubview(nameTextField)
        nameTextField.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == upperView.bottomAnchor + Constants.doubleOffset * 2
        }
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        return nameTextField
    }

    func makeBirthdayPicker(upperView: UIView) -> UIDatePicker {
        let birthdayPicker = UIDatePicker()
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        birthdayPicker.minimumDate = Date() - Constants.secInMaxAgeYears

        view.addSubview(birthdayPicker)
        birthdayPicker.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == upperView.bottomAnchor + Constants.offset
        }
        birthdayPicker.addAction(.init(handler: { _ in
            self.onPickerDateSelected(picker: birthdayPicker)
        }), for: .valueChanged)
        return birthdayPicker
    }

    func onPickerDateSelected(picker: UIDatePicker) {
        ageInMonths = Int((Date() - picker  .date) / Constants.secInMon)
//        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    func setupPhotoImageView(upperView: UIView) {
        photoImageView = ViewFactory.makePhotoImageView(
            image: UIImage(named: "yellowFaceIcon"),
            upperView: upperView,
            parentView: view,
            size: Constants.imageSize,
            offset: Constants.tripleOffset
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tap)
    }

    func setupBirthdayScreenButton() {
        showBirthdayScreenButton.setTitle("Show birthday screen", for: .normal)
        view.addSubview(showBirthdayScreenButton)
        showBirthdayScreenButton.layout { (builder) in
            builder.height == Constants.buttonHeight
            builder.leading == view.leadingAnchor + Constants.offset
            builder.trailing == view.trailingAnchor - Constants.offset
            builder.bottom == view.safeAreaLayoutGuide.bottomAnchor -
                Constants.offset
        }
        showBirthdayScreenButton.addAction(.init(handler: { _ in
            self.onBirthdayScreenButtonTap()
        }), for: .touchUpInside)
    }

    func setupUI() {
        let label = makeTitleLabel()
        let nameTextField = makeTextField(upperView: label)
        let birthdayPicker = makeBirthdayPicker(upperView: nameTextField)
        setupPhotoImageView(upperView: birthdayPicker)
        setupBirthdayScreenButton()
    }

    private func onBirthdayScreenButtonTap() {
        controller.viewDidReceiveTapOnBirthdayScreenButton(
            childData: ChildData(
                name: name,
                ageInMonths: ageInMonths,
                image: photoImageView.image,
                imageIsPlaceholder: !didPickImage
            )
        )
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        imagePicker.present(from: view)
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        let shouldChange = newText.isEmpty ||
            (newText.allSatisfy(\.isLetter) && newText.count <= Constants.maxNameLen)
        if shouldChange {
            name = newText
        }
        return shouldChange
    }
}

extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        didPickImage = true
        photoImageView.image = image
    }
}
