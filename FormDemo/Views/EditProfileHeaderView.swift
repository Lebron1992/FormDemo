//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import UIKit

private let kAvatarSize: CGFloat = 90

final class EditProfileHeaderView: UIView {

    static let kHeight: CGFloat = 165

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = kAvatarSize / 2
        imageView.image = #imageLiteral(resourceName: "avatar")
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(UIColor(named: "actionButtonTitle"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "lightGray")

        addSubviews()
        addLayoutConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Initializations

    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(changePhotoButton)
    }

    private func addLayoutConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: kAvatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: kAvatarSize),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            changePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ])
    }
}
