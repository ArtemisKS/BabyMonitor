//
//  ActionButtonShadow.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import UIKit

class ActionButton: UIButton {

    private var primaryColor: UIColor = .primaryRed

    var buttonIsEnabled: Bool {
        get {
            isEnabled
        }
        set {
            isEnabled = newValue
            setBackgroundColor()
        }
    }

    convenience init() {
        self.init(type: .system)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.cornerRadius == 0 && bounds.height != 0 {
            configure()
        }
    }

    /// Setup the view, mandatory to call if setting the button's frame with anchors
    private func configure() {
        setupView()
        setupLabel()
    }

    func setBackground(color: UIColor) {
        primaryColor = color
        setBackgroundColor()
    }

    private func setBackgroundColor() {
        backgroundColor = isEnabled ? primaryColor : .grayText
    }

    private func setupLabel() {
        titleLabel?.font = Font.textTitleBold
        setTitleColor(.white, for: .normal)
    }

    private func setupView() {
        layer.cornerRadius = bounds.height / 2
        setBackgroundColor()
    }
}
