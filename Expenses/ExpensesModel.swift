//
//  ExpensesModel.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

class ExpensesData: Codable {

    private var data: [Expenses] = []

    init() {
        if let downloadedModels = getFromUserDefaults() {
            self.initWith(downloadedModels)
        } else {
            create()
        }
    }

    private func initWith(_ data: [Expenses]) {
        self.data = data
    }

    var current: Expenses? {
        var result: Expenses? = nil
        data.forEach({ item in
            if !item.ended {
                result = item
            }
        })
        return result
    }

    var archivedExpenses: [Expenses] {
        var archived = data
        for (index, item) in archived.enumerated() {
            if !item.ended {
                archived.remove(at: index)
                break
            }
        }
        return archived
    }

    func start(_ model: ExpensesModel) {
        let current = Expenses()
        current.models.append(model)
        data.append(current)
        save()
    }

    func update(_ model: ExpensesModel) {
        guard let current = self.current else {return}
        var isNew = true
        for (index, item) in current.models.enumerated() {
            if item.isEqualTo(model) {
                current.models.remove(at: index)
                current.models.insert(model, at: index)
                isNew = false
                break
            }
        }

        if isNew {
            current.models.append(model)
        }
        save()
    }

    func endPeriod(_ model: Expenses) {
        model.ended = true
        for (index, item) in data.enumerated() {
            if item.isEqualTo(model) {
                data.remove(at: index)
                data.insert(model, at: index)
                break
            }
        }

        save()
    }

    func delete(_ model: ExpensesModel) {
        data.forEach({ item in
            for (index, expense) in item.models.enumerated() {
                if expense.isEqualTo(model) {
                    item.models.remove(at: index)
                    break
                }
            }
        })

        save()
    }

    private func save() {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self.data)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        let defaults = UserDefaults.standard
        defaults.setValue(json, forKey: "ExpensesDataForApplication")
        defaults.synchronize()
    }

    private func getFromUserDefaults() -> [Expenses]? {
        var data: [Expenses]? = nil
        let defaults = UserDefaults.standard
        if let jsonString = defaults.value(forKey: "ExpensesDataForApplication") as? String, let jsonData = jsonString.data(using: .utf8) {
            let jsonDecoder = JSONDecoder()
            data = try! jsonDecoder.decode([Expenses].self, from: jsonData)
        }
        return data
    }

    private func create() {
        let data = Expenses()
        data.models.append(ExpensesModel(name: "item 1", limit: 14500))
        data.models.append(ExpensesModel(name: "item 2", limit: 8000))
        data.models.append(ExpensesModel(name: "item 3", limit: 15500))
        data.models.append(ExpensesModel(name: "item 4", limit: 10000))
        data.models.append(ExpensesModel(name: "item 5", limit: 8000))
        data.models.append(ExpensesModel(name: "item 6", limit: 8000))
        data.models.append(ExpensesModel(name: "item 7", limit: 10000))
        self.data.append(data)
        save()
    }

    private func clear() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "ExpensesDataForApplication")
        defaults.synchronize()
    }

}

class Expenses: Codable {

    var models: [ExpensesModel] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
    var ended: Bool = false
    var isEmpty: Bool {
        return models.count == 0
    }

    lazy var totalSpent: String = {
        var result: CGFloat = 0
        models.forEach({ result += $0.getSpent() })
        return String(format: "%.2f", result)
    }()

    lazy var totalLimit: String = {
        var result: CGFloat = 0
        models.forEach({ result += $0.getLimit() })
        return String(format: "%.2f", result)
    }()

    private var id: Int

    init() {
        self.id = Int(arc4random_uniform(10000000))
    }

    func getDate() -> String {
        var result = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        result = dateFormatter.string(from: endDate)

        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: startDate)
        let startMonth = calendar.component(.month, from: startDate)
        let startDay = calendar.component(.day, from: startDate)
        let endYear = calendar.component(.year, from: endDate)
        let endMonth = calendar.component(.month, from: endDate)
        let endDay = calendar.component(.day, from: endDate)

        if startYear == endYear {
            dateFormatter.dateFormat = "d MMMM"
        }
        if startMonth == endMonth {
            dateFormatter.dateFormat = "d"
        }
        if startDay == endDay {
            dateFormatter.dateFormat = ""
        }
        let startDateString = dateFormatter.string(from: startDate)

        result = startDateString == "" ? result : startDateString + " - " + result

        return result
    }

    func isEqualTo(_ model: Expenses) -> Bool {
        return id == model.id
    }
}

class ExpensesModel: Codable {
    var name: String
    var percentage: CGFloat {
        if limit == 0 { return 0 }
        return spent/limit
    }
    var rest: CGFloat {
        return limit - spent
    }
    private var limit: CGFloat
    private var spent: CGFloat
    private var id: Int

    init() {
        self.name = ""
        self.limit = 0
        self.spent = 0
        self.id = Int(arc4random_uniform(10000000))
    }

    init(name: String, limit: CGFloat) {
        self.name = name
        self.limit = limit
        self.spent = 0
        self.id = Int(arc4random_uniform(10000000))
    }

    func setLimit(_ value: CGFloat) {
        self.limit = value
    }

    func getLimit() -> CGFloat {
        return self.limit
    }

    func getLimit() -> String {
        return String(format: "%.0f", self.limit)
    }

    func addSpent(_ value: CGFloat) {
        self.spent += value
    }

    func changeSpent(_ value: CGFloat) {
        self.spent = value
    }

    func getSpent() -> CGFloat {
        return spent
    }

    func getSpent() -> String {
        return String(format: "%.2f", self.spent)
    }

    func getRest() -> String {
        return String(format: "%.2f", self.rest)
    }

    func changeName(_ name: String) {
        self.name = name
    }

    func isEqualTo(_ model: ExpensesModel) -> Bool {
        return id == model.id
    }
}

protocol ExpensesDelegate: class {
    func update(_ model: ExpensesModel)
    func endPeriod(_ model: Expenses)
    func delete(_ model: ExpensesModel)
}

