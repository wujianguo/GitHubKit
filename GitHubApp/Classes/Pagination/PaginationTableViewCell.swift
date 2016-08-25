//
//  PaginationTableViewCell.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import ObjectMapper

class PaginationTableViewCell<T: Mappable>: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var item: T! = nil {
        didSet {
            updateUI()
        }
    }

    func setupUI() {

    }

    func updateUI() {

    }
}