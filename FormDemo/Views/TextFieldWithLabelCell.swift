//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import UIKit

protocol TextFieldWithLabelCellDelegate: class {
    func cellFrameWhenEditing(frame: CGRect)
}

final class TextFieldWithLabelCell: UITableViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()

    private var textFieldEditingChanged: ((String?) -> Void)?
    weak var delegate: TextFieldWithLabelCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        addLayoutConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }

    private func addLayoutConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -16),
            label.widthAnchor.constraint(equalToConstant: 120),

            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.heightAnchor.constraint(equalTo: label.heightAnchor),
            textField.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        textFieldEditingChanged?(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func update(with formItem: EditProfileFormTextFieldWithLabelItem) {
        label.text = formItem.label
        textField.text = formItem.value
        textField.placeholder = formItem.placeholder
        textFieldEditingChanged = formItem.valueChanged
    }
}

extension TextFieldWithLabelCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.cellFrameWhenEditing(frame: frame)
    }
}
