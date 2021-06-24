//
//  ViewFactory.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 24.06.2021.
//

import UIKit

enum ViewFactory {

    static func makePhotoImageView(
        image: UIImage?,
        upperView: UIView,
        parentView: UIView,
        size: CGFloat,
        upperOffset: CGFloat
    ) -> UIImageView {
        let photoImageView = UIImageView(image: image)
        photoImageView.contentMode = .scaleAspectFill
        parentView.addSubview(photoImageView)
        photoImageView.layout { (builder) in
            builder.top == upperView.bottomAnchor + upperOffset
            builder.centerX == parentView.centerXAnchor
            builder.width == size
            builder.height == size
        }
        photoImageView.setCornerRadius(size / 2)
        return photoImageView
    }
}
