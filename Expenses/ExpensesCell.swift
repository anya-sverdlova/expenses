//
//  ExpensesCell.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class ExpensesCell: UITableViewCell {

    var model: ExpensesModel? {
        didSet {
            if model != nil {
                setData()
            }
        }
    }

    lazy var mainWidth: CGFloat = {
        return self.frame.width - 32
    }()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountViewContainer: UIView!
    @IBOutlet weak var amountViewWidth: NSLayoutConstraint!

    override func prepareForReuse() {
        nameLabel.text = ""
        amountLabel.text = ""
        amountViewWidth.constant = 0
        amountView.backgroundColor = .systemTeal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func setData() {
        amountView.layer.cornerRadius = 4
        amountViewContainer.layer.cornerRadius = 4
        guard let model = self.model else {return}
        let percentage = model.percentage
        nameLabel.text = model.name
        amountLabel.text = "потрачено " + model.getSpent() + " из " + model.getLimit() + ", остаток " + model.getRest()
        amountViewWidth.constant = percentage > 1 ? mainWidth : percentage * mainWidth
        var background: UIColor
        switch percentage {
        case _ where percentage >= 1:
            background = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        case _ where percentage >= 0.75:
            background = .orange
        case _ where percentage >= 0.5:
            background = UIColor(red: 0.99, green: 0.95, blue: 0.00, alpha: 1.00)
        case _ where percentage >= 0.25:
            background = UIColor(red: 0.40, green: 0.92, blue: 0.00, alpha: 1.00)
        default:
            background = .systemTeal
        }
        amountView.backgroundColor = background
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}
