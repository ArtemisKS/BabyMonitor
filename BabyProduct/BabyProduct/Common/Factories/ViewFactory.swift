//
//  ViewFactory.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 24.06.2021.
//

import UIKit

enum Constants {
    static let offset: CGFloat = 16
    static let doubleOffset: CGFloat = offset * 2
    static let tripleOffset: CGFloat = offset * 3
}

enum ViewFactory {

    enum Const {
        static let shareButtonWidth: CGFloat = 182
    }

    static func makePhotoImageView(
        image: UIImage?,
        upperView: UIView,
        parentView: UIView,
        size: CGFloat,
        offset: CGFloat
    ) -> UIImageView {
        let photoImageView = UIImageView(image: image)
        photoImageView.contentMode = .scaleAspectFill
        parentView.addSubview(photoImageView)
        photoImageView.layout {
            if upperView === parentView {
                $0.bottom == parentView.bottomAnchor - offset
            } else {
                $0.top == upperView.bottomAnchor + offset
            }
            $0.centerX == parentView.centerXAnchor
            $0.width == size
            $0.height == size
        }
        photoImageView.setCornerRadius(size / 2)
        return photoImageView
    }

    static func makeSwirlImageView(left: Bool, size: CGFloat) -> UIImageView {
        let swirlImageView = UIImageView(
            image: UIImage(named: left ? "leftSwirl" : "rightSwirl")
        )
        swirlImageView.contentMode = .scaleAspectFit
        swirlImageView.layout {
            $0.width == size
        }
        return swirlImageView
    }

    static func makeShareButton(
        parentView: UIView,
        upperView: UIView,
        lowerView: UIView,
        isModelX: Bool
    ) -> UIButton {

        let shareBackView = makeShareBackView()

        let shareButton = UIButton(type: .custom)
        shareButton.addSubview(shareBackView)
        parentView.addSubview(shareButton)
        let shareVerticalOffset = isModelX ?
            Constants.doubleOffset : Constants.offset
        shareButton.layout {
            $0.centerX == parentView.centerXAnchor
            $0.leading == shareBackView.leadingAnchor
            $0.top == shareBackView.topAnchor
            $0.trailing == shareBackView.trailingAnchor
            $0.bottom == shareBackView.bottomAnchor
            $0.bottom == lowerView.topAnchor - shareVerticalOffset * 1.5
            $0.top == upperView.bottomAnchor + shareVerticalOffset
        }
        return shareButton
    }

    private static func makeShareBackView() -> UIView {

        let shareImageView = UIImageView(image: UIImage(named: "shareArrowIcon"))
        shareImageView.contentMode = .scaleAspectFit

        shareImageView.layout {
            $0.width == Constants.offset * 1.5
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

        let shareBackView = UIView()
        shareBackView.isUserInteractionEnabled = false
        for subview in [shareBackImageView, shareStackView] {
            shareBackView.addSubview(subview)
        }

        shareBackImageView.layout {
            $0.width == Const.shareButtonWidth
            $0.height == Constants.tripleOffset
        }

        shareBackView.layout {
            $0.leading == shareBackImageView.leadingAnchor
            $0.top == shareBackImageView.topAnchor
            $0.trailing == shareBackImageView.trailingAnchor
            $0.bottom == shareBackImageView.bottomAnchor
        }

        shareStackView.layout {
            $0.leading == shareBackView.leadingAnchor + Constants.offset
            $0.top == shareBackView.topAnchor
            $0.bottom == shareBackView.bottomAnchor - Constants.offset / 4
        }
        return shareBackView
    }

    static func makeUpperStackView(
        childData: ChildData,
        parentView: UIView,
        isModelX: Bool,
        makeAge: (Int) -> Int,
        makeAgeText: (Bool, Int) -> String
    ) -> UIStackView {

        let nameLabel = UILabel()
        nameLabel.text = "Today \(childData.name) is".uppercased()

        let actualAge = makeAge(childData.ageInMonths)
        let numberImageView = UIImageView(image: UIImage(named: "\(actualAge)icon"))
        numberImageView.contentMode = .scaleAspectFit

        let numberImageSize: CGFloat = isModelX ? 132 : 104

        let ageThresholder = 10
        numberImageView.layout {
            $0.height == (actualAge < ageThresholder ? numberImageSize : numberImageSize / 1.35)
            $0.width == (actualAge < ageThresholder ? numberImageSize / 1.35 : numberImageSize)
        }

        let swirlImageSize: CGFloat = isModelX ? 62 : 50

        let leftSwirlImageView = makeSwirlImageView(
            left: true,
            size: swirlImageSize
        )

        let rightSwirlImageView = makeSwirlImageView(
            left: false,
            size: swirlImageSize
        )

        let imagesStackView = UIStackView(
            arrangedSubviews: [leftSwirlImageView, numberImageView, rightSwirlImageView]
        )
        imagesStackView.axis = .horizontal
        imagesStackView.spacing = Constants.offset

        let lowerLabel = UILabel()
        lowerLabel.text = makeAgeText(
            actualAge != childData.ageInMonths,
            actualAge
        ).uppercased()

        for label in [nameLabel, lowerLabel] {
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 25, weight: .semibold)
            label.textColor = .customBlack
            label.textAlignment = .center
        }

        let upperStackView = UIStackView(arrangedSubviews: [nameLabel, imagesStackView, lowerLabel])
        upperStackView.axis = .vertical
        upperStackView.spacing = Constants.offset / 2

        parentView.addSubview(upperStackView)
        upperStackView.layout {
            $0.centerX == parentView.centerXAnchor
        }
        return upperStackView
    }
}
