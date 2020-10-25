//
//  ArchiveViewController.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class ArchiveViewController: UIViewController {

    var expenses: ExpensesData!
    var isActivePeriod: Bool {
        return expenses.current != nil
    }
    weak var delegate: ExpensesDelegate?
    private var checkedItem: Expenses?

    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchPeriodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction func switchPeriodButtonTapped(_ sender: Any) {
        if isActivePeriod {
            delegate?.endPeriod(expenses.current!)
            tableView.reloadData()
            setupUI()
        } else {
            navigationController?.popViewController(animated: true)
        }

    }

    private func setupUI() {
        currentPeriodLabel.text = isActivePeriod ? "Current expense period: " + expenses.current!.getDate() : "You don't start current expense period"
        switchPeriodButton.setTitle(isActivePeriod ? "End expense period" : "Start expense period", for: .normal)
        tableView.isHidden = expenses.archivedExpenses.count == 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "archiveDetail" {

        }
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.archivedExpenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell") as? ArchiveCell else { return UITableViewCell() }
        cell.model = expenses.archivedExpenses[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Archive", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "ArchiveDetailViewController") as! ArchiveDetailViewController
        detailVC.model = expenses.archivedExpenses[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
