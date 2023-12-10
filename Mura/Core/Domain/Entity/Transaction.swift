//
//  TransactionEntity.swift
//  Mura
//
//  Created by Ferry Dwianta P on 30/09/23.
//

import Foundation

enum TransactionType: String {
    case expense = "Expense"
    case income = "Income"
}

struct Transaction: Identifiable {
    let id: UUID
    let date: Date
    let category: Category
    let note: String?
    let amount: Double
    let type: TransactionType
}

struct CategoryModel {
    let name: String
    let icon: String
}

enum Category {
    case expense(ExpenseCategory)
    case income(IncomeCategory)
    
    enum ExpenseCategory: String, CaseIterable {
        case food
        case entertainment
        
        func getExpenseData() -> CategoryModel {
            switch self {
            case .food:
                CategoryModel(name: "Food", icon: "food")
            case .entertainment:
                CategoryModel(name: "Entertainment", icon: "entertainment")
            }
        }
    }
    
    enum IncomeCategory: String, CaseIterable {
        case salary
        case gift
        
        func getIncomeData() -> CategoryModel {
            switch self {
            case .salary:
                CategoryModel(name: "Salary", icon: "salary")
            case .gift:
                CategoryModel(name: "Gift", icon: "gift")
            }
        }
    }
    
    static func categoryFromString(_ string: String) -> Category? {
        if let expenseCategory = ExpenseCategory(rawValue: string) {
            return .expense(expenseCategory)
        } else if let incomeCategory = IncomeCategory(rawValue: string) {
            return .income(incomeCategory)
        }
        return nil
    }
}

// Data model for tableView sections
struct TransactionSection {
    let sectionTitle: String // data model: date, totalAmount
    var transactions: [Transaction]
}
