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
        static let buttonHeight: CGFloat = 48
        static let datePickerWidth: CGFloat = 280
        static let secInDay: TimeInterval = 60 * 60 * 24
        static let secInMon: TimeInterval = secInDay * 30
        static let secInYear: TimeInterval = secInMon * 12
    }

    private let controller: HomeControlling

    private let showBirthdayScreenButton = ActionButton()

    @Published private var name = ""
    @Published private var ageInMonths = 0

    private var cancellable: AnyCancellable?

    private var validToSubmit: AnyPublisher<Bool, Never> {
      return Publishers.CombineLatest($name, $ageInMonths)
        .map { name, age in
          !name.isEmpty && age > 0 && age < 13
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

        setupUI()
        subscribeOnButtonUpdates()
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

        showBirthdayScreenButton.setTitle("Show birthday screen", for: .normal)

        view.addSubview(showBirthdayScreenButton)
        showBirthdayScreenButton.layout { (builder) in
            builder.height == Constants.buttonHeight
            builder.leading == view.leadingAnchor + Constants.offset
            builder.trailing == view.trailingAnchor - Constants.offset
            builder.bottom == view.bottomAnchor - Constants.buttonHeight
        }
        showBirthdayScreenButton.addAction(.init(handler: { _ in
            self.controller.viewDidReceiveTapOnBirthdayScreenButton(
                name: self.name,
                age: self.ageInMonths
            )
        }), for: .touchUpInside)
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
            (newText.contains(where: \.isLetter) && newText.count <= 30)
        if shouldChange {
            name = newText
        }
        return shouldChange
    }
}
