//
//  ArchiveDetailViewController.swift
//  Expenses
//
//  Created by Anna Sverdlova on 05.10.2020.
//

import UIKit

class ArchiveDetailViewController: UIViewController {

    var model: Expenses!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

    private func setupUI() {
        dateLabel.text = model.getDate()
    }
}

extension ArchiveDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as? ExpensesCell else {
            return UITableViewCell()
        }
        cell.model = model.models[indexPath.row]
        return cell
    }


}
