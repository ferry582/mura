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
    var amount: Double
    let type: TransactionType
}
