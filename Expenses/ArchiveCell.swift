//
//  ArchiveCell.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class ArchiveCell: UITableViewCell {

    var model: Expenses! {
        didSet {
            setData()
        }
    }

    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        periodLabel.text = ""
        amountLabel.text = ""
    }

    private func setData() {
        periodLabel.text = model.getDate()
        amountLabel.text = "Spent " + model.totalSpent + ", limit " + model.totalLimit
    }
}
