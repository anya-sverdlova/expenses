//
//  DetailViewController.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class DetailViewController: UIViewController {

    var model: ExpensesModel!
    weak var delegate: ExpensesDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonOnKeyboard()
        self.title = "Detail"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(correctButtonTapped)), animated: false)

        setData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let s = amountTextField.text, let number = Double(s).map({ CGFloat($0) }) {
            model.addSpent(number)
        }
        delegate?.update(model)
        navigationController?.popViewController(animated: true)
    }

    private func setData() {
        nameLabel.text = model.name
        limitLabel.text = model.getLimit()
        spentLabel.text = model.getSpent()
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        amountTextField.inputAccessoryView = doneToolbar
        amountTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        amountTextField.resignFirstResponder()
    }

    @objc func correctButtonTapped() {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        guard let destination = storyboard.instantiateViewController(withIdentifier: "ChangeViewController") as? ChangeViewController else {return}
        destination.model = self.model
        destination.changeCase = .correct
        destination.delegate = self.delegate
        navigationController?.pushViewController(destination, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChangeViewController else {return}
        destination.model = self.model
        destination.changeCase = .correct
        destination.delegate = self.delegate
    }

}
