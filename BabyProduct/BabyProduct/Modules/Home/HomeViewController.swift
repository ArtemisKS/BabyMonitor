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

    enum Constants {
        static let offset: CGFloat = 16
        static let doubleOffset: CGFloat = offset * 2
        static let tripleOffset: CGFloat = offset * 3
        static let imageSize: CGFloat = 240
        static let buttonHeight: CGFloat = 48
        static let datePickerWidth: CGFloat = 280
        static let secInDay: TimeInterval = 60 * 60 * 24
        static let secInMon: TimeInterval = secInDay * 30
        static let secInYear: TimeInterval = secInMon * 12
        static let minAgeMonths = 1
        static let maxAgeMonths = 12
    }

    private let controller: HomeControlling

    private let showBirthdayScreenButton = ActionButton()
    private var photoImageView: UIImageView!
    private var imagePicker: ImagePicker!

    @Published private var name = ""
    @Published private var ageInMonths = 0

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

    private func setupUI() {
        let label = UILabel()
        label.text = "Baby monitor"
        label.font = .systemFont(ofSize: 25, weight: .bold)

        view.addSubview(label)
        label.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == view.topAnchor + (Constants.offset + UIApplication.topSafeArea)
        }

        let nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"

        view.addSubview(nameTextField)
        nameTextField.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == label.bottomAnchor + Constants.doubleOffset * 2
        }
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self

        let birthdayPicker = UIDatePicker()
        birthdayPicker.datePickerMode = .date
        birthdayPicker.maximumDate = Date()
        birthdayPicker.minimumDate = Date() - Constants.secInYear

        view.addSubview(birthdayPicker)
        birthdayPicker.layout { (builder) in
            builder.centerX == view.centerXAnchor
            builder.top == nameTextField.bottomAnchor + Constants.offset
        }
        birthdayPicker.addAction(.init(handler: { _ in
            let date = birthdayPicker.date
            self.ageInMonths = Int((Date() - date) / Constants.secInMon)
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }), for: .valueChanged)

        photoImageView = ViewFactory.makePhotoImageView(
            image: UIImage(named: "yellowFaceIcon"),
            upperView: birthdayPicker,
            parentView: view,
            size: Constants.imageSize,
            upperOffset: Constants.tripleOffset
        )
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tap)

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

    private func onBirthdayScreenButtonTap() {
        controller.viewDidReceiveTapOnBirthdayScreenButton(
            childData: ChildData(
                name: name,
                ageInMonths: ageInMonths,
                image: photoImageView.image
            )
        )
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        imagePicker.present(from: view)
    }

    private func subscribeOnButtonUpdates() {
        cancellable = validToSubmit
          .receive(on: RunLoop.main)
          .assign(to: \.buttonIsEnabled, on: showBirthdayScreenButton)
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
            (newText.allSatisfy(\.isLetter) && newText.count <= 30)
        if shouldChange {
            name = newText
        }
        return shouldChange
    }
}

extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        photoImageView.image = image
    }
}
