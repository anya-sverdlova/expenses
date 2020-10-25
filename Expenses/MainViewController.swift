//
//  MainViewController.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class MainViewController: UIViewController {

    var expensesData = ExpensesData()
    var expenses: Expenses? {
        return expensesData.current
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Expenses"

        navigationItem.setRightBarButton(UIBarButtonItem(title: "Archive", style: .plain, target: self, action: #selector(openArchive)), animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()
    }

    private func updateUI() {
        dateLabel.text = expenses?.getDate()
        if expenses == nil {
            tableView.isHidden = true
            instructionLabel.isHidden = false
        } else {
            tableView.isHidden = false
            tableView.reloadData()
            instructionLabel.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChangeViewController else {return}
        destination.delegate = self
        destination.changeCase = .create
    }

    @objc func openArchive() {
        let storyboard = UIStoryboard(name: "Archive", bundle: nil)
        let archiveVC = storyboard.instantiateViewController(withIdentifier: "ArchiveViewController") as! ArchiveViewController
        archiveVC.delegate = self
        archiveVC.expenses = expensesData
        navigationController?.pushViewController(archiveVC, animated: true)
    }
    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses?.models.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as? ExpensesCell else {
            return UITableViewCell()
        }
        cell.model = expenses?.models[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.delegate = self
        detailVC.model = expenses?.models[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension MainViewController: ExpensesDelegate {
    func update(_ model: ExpensesModel) {
        if expenses == nil {
            expensesData.start(model)
        } else {
            expensesData.update(model)
        }
    }

    func endPeriod(_ model: Expenses) {
        expensesData.endPeriod(model)
    }

    func delete(_ model: ExpensesModel) {
        expensesData.delete(model)
    }
}

