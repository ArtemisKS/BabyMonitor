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
        offset: CGFloat
    ) -> UIImageView {
        let photoImageView = UIImageView(image: image)
        photoImageView.contentMode = .scaleAspectFill
        parentView.addSubview(photoImageView)
        photoImageView.layout { (builder) in
            if upperView === parentView {
                builder.bottom == parentView.bottomAnchor - offset
            } else {
                builder.top == upperView.bottomAnchor + offset
            }
            builder.centerX == parentView.centerXAnchor
            builder.width == size
            builder.height == size
        }
        photoImageView.setCornerRadius(size / 2)
        return photoImageView
    }
}
