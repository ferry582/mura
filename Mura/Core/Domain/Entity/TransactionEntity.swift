//
//  TransactionEntity.swift
//  Mura
//
//  Created by Ferry Dwianta P on 30/09/23.
//

import Foundation

enum TransactionType {
    case expense
    case income
}

struct TransactionEntity {
//    let id
    let date: Date
    let category: String
    let note: String
    let amount: Double
    let type: TransactionType
    
    static let transactionData1: [TransactionEntity] = [
        TransactionEntity(date: Date(timeIntervalSince1970: 1696175503450), category: "Food", note: "makan malam", amount: 133000, type: .income),
        TransactionEntity(date: Date(timeIntervalSince1970: 1696175503450), category: "Food", note: "makan malam", amount: -1000, type: .expense),
        TransactionEntity(date: Date(timeIntervalSince1970: 1696175503450), category: "Food", note: "makan malam", amount: 1000, type: .income)
    ]
    
    static let transactionData2: [TransactionEntity] = [
        TransactionEntity(date: Date(timeIntervalSince1970: 1696006800000), category: "Food", note: "makan malam", amount: 12000, type: .income),
        TransactionEntity(date: Date(timeIntervalSince1970: 1696006800000), category: "Food", note: "makan malam", amount: -65000, type: .expense),
    ]
}

// Data model for tableView sections
struct TransactionSection {
    let sectionTitle: String // data model: date, totalAmount
    var transactions: [TransactionEntity]
}

struct Category {
    let name: String
    let icon: String
}

enum ExpenseCategory {
    case food
    case entertainment
    
    func getExpenseCategory() -> Category {
        switch self {
        case .food:
            Category(name: "Food", icon: "food")
        case .entertainment:
            Category(name: "Entertainment", icon: "entertainment")
        }
    }
    
}

var food: ExpenseCategory = .food
var foodName = food.getExpenseCategory().name
