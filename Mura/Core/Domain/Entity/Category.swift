//
//  Category.swift
//  Mura
//
//  Created by Ferry Dwianta P on 10/12/23.
//

import Foundation

struct Category: Equatable {
    let id: Int
    let name: String
    let icon: String
    
    static let emptyCategory = Category(id: 0, name: "None", icon: "")
    
    static let expenseCategories =  [
        emptyCategory,
        Category(id: 1, name: "Food", icon: "food"),
        Category(id: 2, name: "Entertainment", icon: "entertainement"),
    ]
    
    static let incomeCategories = [
        emptyCategory,
        Category(id: 1, name: "Salary", icon: "salary"),
        Category(id: 2, name: "Gift", icon: "gift")
    ]
    
    static func getCategoryById(categoryId: Int, transactionType: TransactionType) -> Category {
        if transactionType == .expense {
            return expenseCategories.first { $0.id == categoryId }!
        } else {
            return incomeCategories.first { $0.id == categoryId }!
        }
    }
}
