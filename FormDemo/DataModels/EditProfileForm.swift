//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import Foundation

final class EditProfileForm {
    var formItems: [EditProfileFormItemType] = []

    var avatarURL: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?

    init(avatarURL: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         username: String? = nil,
         email: String? = nil) {

        self.avatarURL = avatarURL
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email

        configureItems()
    }

    private func configureItems() {
        let firstNameItem = EditProfileFormTextFieldWithLabelItem(label: "First Name",
                                                                  value: firstName,
                                                                  placeholder: "First Name")
        firstNameItem.valueChanged = { [weak self, weak firstNameItem] (text) in
            self?.firstName = text
            firstNameItem?.value = text
        }

        let lastNameItem = EditProfileFormTextFieldWithLabelItem(label: "Last Name",
                                                                 value: lastName,
                                                                 placeholder: "Last Name")
        lastNameItem.valueChanged = { [weak self, weak lastNameItem] (text) in
            self?.lastName = text
            lastNameItem?.value = text
        }

        let usernameItem = EditProfileFormTextFieldWithLabelItem(label: "Username",
                                                                 value: username,
                                                                 placeholder: "Username")
        usernameItem.valueChanged = { [weak self, weak usernameItem] (text) in
            self?.username = text
            usernameItem?.value = text
        }

        let emailItem = EditProfileFormTextFieldWithLabelItem(label: "Email",
                                                              value: email,
                                                              placeholder: "Email")
        emailItem.valueChanged = { [weak self, weak emailItem] (text) in
            self?.email = text
            emailItem?.value = text
        }

        formItems = [firstNameItem, lastNameItem, usernameItem, emailItem]
    }
}
