//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var headerView: EditProfileHeaderView = {
        let frame = CGRect(x: 0, y: 0,
                           width: view.bounds.width,
                           height: EditProfileHeaderView.kHeight)
        let headerView = EditProfileHeaderView(frame: frame)
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.tableHeaderView = headerView
        tableView.register(cellClass: TextFieldWithLabelCell.self, forCellReuseIdentifier: .textFieldWithLabelCell)
        return tableView
    }()

    private lazy var form: EditProfileForm = {
        let form = EditProfileForm(avatarURL: "",
                                   firstName: "Lebron",
                                   lastName: "James",
                                   username: "Lebron James",
                                   email: "test@test.com")
        return form
    }()

    private var editingCellFrame: CGRect = .zero
    private var originalContentOffset: CGPoint = .zero

    // MARK: - Load View

    override func loadView() {
        view = UIView()
        addTableView()
    }

    private func addTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    // MARK: - View Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        observeKeyboardFrameChange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        removeObservers()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.formItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        if let tfItem = formItem(at: indexPath) as? EditProfileFormTextFieldWithLabelItem,
            let tfCell = tableView.dequeueReusableCell(withIdentifier: .textFieldWithLabelCell, for: indexPath)
                as? TextFieldWithLabelCell {

            tfCell.delegate = self
            tfCell.update(with: tfItem)
            cell = tfCell
        }

        return cell
    }

    // MARK: Helper Methods

    private func formItem(at indexPath: IndexPath) -> EditProfileFormItemType? {
        guard indexPath.row < form.formItems.count else { return nil }
        return form.formItems[indexPath.row]
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - Keyboard Notifications
extension ViewController {
    private func observeKeyboardFrameChange() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardwillShow(_:)),
                         name: .UIKeyboardWillShow,
                         object: nil)

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardwillHide(_:)),
                         name: .UIKeyboardWillHide,
                         object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default
            .removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardwillShow(_ noti: Notification) {
        originalContentOffset = tableView.contentOffset

        guard let endFrame = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {  return }

        // 更新contentInset.bottom
        // 原因：如果我们点击的是最上面的Cell，这里是First Name，然后往上滑动到最底部，
        // 如果contentInset.bottom还是0的话，最下面的Cell就会看不到
        // 所以我们给bottom设置一个值，tableview的内容就会网上移动，
        // 而移动的距离正好是键盘高度减去tabBar的高度
        // 如果我们是滑动tableview就隐藏键盘，就没有这个问题，大家看实际需求来选择
        let newContentInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: endFrame.height - tabBarHeight,
                                           right: 0)
        tableView.contentInset = newContentInset

        // 根据刚刚的分析，要求出tableview网上移动的距离：
        // 可以通过正在编辑的Cell的maxY减去键盘的Y值计算
        // 但是要先把键盘的frame转换到tableview的坐标系中，
        // 同一个坐标系内进行计算才会得到正确的值
        let endFrameInTable = tableView.convert(endFrame, from: nil)
        let offsetY = editingCellFrame.maxY - endFrameInTable.origin.y

        // 如果网上移动的距离小于0，说明Cell没有被遮挡
        guard offsetY > 0 else { return }

        UIView.animate(withDuration: duration) {
            // 在原来originalContentOffset.y的基础上，再加上要网上滑动的距离
            let offset = CGPoint(x: 0, y: self.originalContentOffset.y + offsetY)
            self.tableView.contentOffset = offset
        }
    }

    @objc private func keyboardwillHide(_ noti: Notification) {
        guard let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }

        UIView.animate(withDuration: duration, animations: {
            self.tableView.contentInset = .zero
            self.tableView.contentOffset = self.originalContentOffset
        })
    }

}

// MARK: - TextFieldWithLabelCellDelegate
extension ViewController: TextFieldWithLabelCellDelegate {
    func cellFrameWhenEditing(frame: CGRect) {
        editingCellFrame = frame
    }
}

