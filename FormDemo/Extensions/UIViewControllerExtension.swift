//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: Notifications

    func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Frames

    var tabBarHeight: CGFloat {
        guard let tabBarController = tabBarController else { return 0 }
        return tabBarController.tabBar.frame.height
    }
}
