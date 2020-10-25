//
//  ChangeViewController.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

enum ChangeCases: String {
    case correct = "Correct"
    case create = "Add"
}

enum ErrorCases: String {
    case name = "Wrong category name"
    case limit = "Wrong category limit"
}

class ChangeViewController: UIViewController {

    var model: ExpensesModel = ExpensesModel(name: "", limit: 0)
    var changeCase: ChangeCases!

    weak var delegate: ExpensesDelegate?

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if changeCase == .correct {
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped)), animated: false)
        }
        setData()
        addDoneButtonOnKeyboard(nameTextField)
        addDoneButtonOnKeyboard(limitTextField)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if changeCase == .correct {
            saveCorrections()
        } else {
            createExpense()
        }
        navigationController?.popToRootViewController(animated: true)
    }

    private func setData() {
        mainLabel.text = changeCase.rawValue + " category"
        if changeCase == .correct {
            nameTextField.text = model.name
            limitTextField.text = model.getLimit()
        }
    }

    private func saveCorrections() {
        if nameTextField.text != model.name && nameTextField.text != nil {
            model.name = nameTextField.text!
        }
        if limitTextField.text != model.getLimit() && limitTextField.text != nil {
            if let number = Double(limitTextField.text!).map({ CGFloat($0) }) {
                model.setLimit(number)
            }
        }
        delegate?.update(model)
    }

    private func createExpense() {
        if nameTextField.text != nil && nameTextField.text != ""{
            model.name = nameTextField.text!
        } else {
            showAlert(ErrorCases.name)
            return
        }
        if let s = limitTextField.text, let number = Double(s).map({ CGFloat($0) }) {
            model.setLimit(number)
        } else {
            showAlert(ErrorCases.limit)
            return
        }
        delegate?.update(model)
    }

    @objc func deleteButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.delegate?.delete(self.model)
            self.navigationController?.popToRootViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(delete)
        alert.addAction(cancel)
        navigationController?.present(alert, animated: true, completion: nil)
    }

    func addDoneButtonOnKeyboard(_ textfield: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        textfield.inputAccessoryView = doneToolbar
        textfield.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        nameTextField.resignFirstResponder()
        limitTextField.resignFirstResponder()
    }

    private func showAlert(_ error: ErrorCases) {
        let alert = UIAlertController(title: "Something went wrong", message: (error == .name ? ErrorCases.name.rawValue : ErrorCases.limit.rawValue), preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        navigationController?.present(alert, animated: true, completion: { [weak self] in
            guard let this = self else {return}
            if error == .name {
                this.nameTextField.text = ""
            }
            if error == .limit {
                this.limitTextField.text = ""
            }
        })
    }

}
