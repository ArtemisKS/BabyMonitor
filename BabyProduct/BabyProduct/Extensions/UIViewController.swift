//
//  UIViewController.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 24.06.2021.
//

import UIKit

// MARK: - Keyboard management

extension UIViewController {

    func startAvoidingKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else { return }

        let safeAreaAndKeyboardIntersection = view.safeAreaLayoutGuide.layoutFrame
            .insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
            .intersection(view.convert(keyboardFrameEnd, from: nil))

        let animationOptions = UIView.AnimationOptions(rawValue: animationCurve.uintValue)

        view.layoutIfNeeded()

        additionalSafeAreaInsets.bottom = safeAreaAndKeyboardIntersection.height

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationOptions,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}

extension UIViewController {
    func execCATransaction(
        animation: @escaping () -> Void,
        completion: @escaping () -> Void) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        animation()
        CATransaction.commit()
    }
}
