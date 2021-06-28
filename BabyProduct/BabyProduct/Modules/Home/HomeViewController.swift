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
    func updatePhoto(_ photo: UIImage)
}

// MARK: -

final class HomeViewController: BaseViewController {

    private enum Const {
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
    private let nameTextField = UITextField()
    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!

    private var didPickPhoto = false

    @Published private var name = ""
    @Published private var ageInMonths = 0

    private var cancellable: AnyCancellable?
    
    private var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($name, $ageInMonths)
            .map { name, age in
                !name.isEmpty &&
                    age >= Const.minAgeMonths && age <= Const.maxAgeMonths
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

        setupChildData()
        startAvoidingKeyboard()
        setupImagePicker()
        setupUI()
        subscribeOnButtonUpdates()
        setupViewTapRecognizer()
    }

    deinit {
        stopAvoidingKeyboard()
    }

    private func setupViewTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleViewTap(_:)))
        view.addGestureRecognizer(tap)
    }

    private func setupChildData() {
        let childCreds = controller.getChildCredentials()
        name = childCreds?.name ?? ""
        ageInMonths = childCreds?.ageInMonths ?? 0
    }

    private func setupImagePicker() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    private func subscribeOnButtonUpdates() {
        cancellable = validToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.buttonIsEnabled, on: showBirthdayScreenButton)
    }

    private func onBirthdayScreenButtonTap() {

        func onButtonTap() {
            controller.viewDidReceiveTapOnBirthdayScreenButton(
                childData: ChildData(
                    name: name,
                    ageInMonths: ageInMonths,
                    image: photoImageView.image
                ),
                didPickPhoto: didPickPhoto
            )
        }

        execCATransaction {
            self.nameTextField.resignFirstResponder()
        } completion: {
            onButtonTap()
        }
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        imagePicker.present(from: view)
    }

    @objc private func handleViewTap(_ sender: UITapGestureRecognizer) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
    }
}

// MARK: - UI Setup

private extension HomeViewController {

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Baby monitor"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold)

        view.addSubview(label)
        label.layout {
            $0.centerX == view.centerXAnchor
            $0.top == view.topAnchor + (Constants.offset + UIApplication.topSafeArea)
        }
        return label
    }

    func makeTextField(upperView: UIView) -> UITextField {
        nameTextField.placeholder = "Enter your name"
        nameTextField.textAlignment = .center
        nameTextField.textColor = .white
        if !name.isEmpty {
            nameTextField.text = name
        }
        nameTextField.autocorrectionType = .no

        view.addSubview(nameTextField)
        nameTextField.layout {
            $0.centerX == view.centerXAnchor
            $0.top == upperView.bottomAnchor + Constants.doubleOffset * 2
        }
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        return nameTextField
    }

    func makeBirthdayPicker(upperView: UIView) -> UIDatePicker {
        let birthdayPicker = UIDatePicker()
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        birthdayPicker.minimumDate = Date() - Const.secInMaxAgeYears
        birthdayPicker.preferredDatePickerStyle = .compact

        if ageInMonths != 0 {
            birthdayPicker.setDate(
                Date() - Double(ageInMonths) * Const.secInMon,
                animated: false
            )
        }

        view.addSubview(birthdayPicker)
        birthdayPicker.layout {
            $0.centerX == view.centerXAnchor
            $0.top == upperView.bottomAnchor + Constants.offset
        }
        birthdayPicker.addAction(.init(handler: { _ in
            self.onPickerDateSelected(picker: birthdayPicker)
        }), for: .valueChanged)
        return birthdayPicker
    }

    func onPickerDateSelected(picker: UIDatePicker) {
        ageInMonths = Int((Date() - picker  .date) / Const.secInMon)
    }

    func setupPhotoImageView(upperView: UIView) {
        let type = controller.getRandomColor()
        photoImageView = ViewFactory.makePhotoImageView(
            image: UIImage(named: "\(type)FaceIcon"),
            upperView: upperView,
            parentView: view,
            size: Const.imageSize,
            offset: Constants.tripleOffset
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tap)

        if let childPhoto = controller.getPhoto() {
            photoImageView.image = childPhoto
        }
    }

    func setupBirthdayScreenButton() {
        showBirthdayScreenButton.setTitle("Show birthday screen", for: .normal)
        view.addSubview(showBirthdayScreenButton)
        showBirthdayScreenButton.layout {
            $0.height == Const.buttonHeight
            $0.leading == view.leadingAnchor + Constants.offset
            $0.trailing == view.trailingAnchor - Constants.offset
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor -
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
}

// MARK: - HomeView

extension HomeViewController: HomeView {

    func updatePhoto(_ photo: UIImage) {
        photoImageView.image = photo
    }
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
        let hasCorrectPattern =
            !newText.trimmed.isEmpty
            && newText != text
            && !(newText.last?.isWhitespace == true
                    && text.last?.isWhitespace == true)
            && newText.allSatisfy { $0.isLetter || $0.isWhitespace }
            && newText.count <= Const.maxNameLen
        let shouldChange =
            newText.isEmpty
            || newText.count < text.count
            || hasCorrectPattern
        if shouldChange {
            name = newText
        }
        return shouldChange
    }
}

extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        didPickPhoto = true
        photoImageView.image = image
    }
}
