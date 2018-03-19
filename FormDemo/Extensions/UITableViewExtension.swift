//
//  ViewController.swift
//  FormDemo
//
//  Created by Lebron on 19/03/2018.
//  Copyright © 2018 Lebron. All rights reserved.
//

import UIKit

enum TableCellIdentifier: String {
    case textFieldWithLabelCell
}

extension UITableView {

    func register(cellClass: AnyClass?,
                  forCellReuseIdentifier id: TableCellIdentifier) {
        register(cellClass, forCellReuseIdentifier: id.rawValue)
    }

    func dequeueReusableCell(withIdentifier id: TableCellIdentifier, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: id.rawValue, for: indexPath)
    }
}
