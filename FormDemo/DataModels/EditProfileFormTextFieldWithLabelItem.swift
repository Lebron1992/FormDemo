//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import Foundation

final class EditProfileFormTextFieldWithLabelItem: EditProfileFormItemType {
    let label: String
    var value: String?
    var placeholder: String?
    var valueChanged: ((String?) -> Void)?

    init(label: String, value: String? = nil, placeholder: String? = nil) {
        self.label = label
        self.value = value
        self.placeholder = placeholder
    }
}
