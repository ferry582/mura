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
    static let otherCategory = Category(id: 999, name: "Other", icon: "ellipsis")
    
    static let expenseCategories =  [
        emptyCategory,
        Category(id: 1, name: "Food", icon: "fork.knife"),
        Category(id: 2, name: "Entertainment", icon: "movieclapper.fill"),
        Category(id: 3, name: "Transportation", icon: "bus.fill"),
        Category(id: 4, name: "Shopping", icon: "bag.fill"),
        Category(id: 5, name: "Education", icon: "graduationcap.fill"),
        Category(id: 6, name: "Health", icon: "pill.fill"),
        Category(id: 7, name: "Comunication", icon: "phone.fill"),
        Category(id: 8, name: "Cafe", icon: "cup.and.saucer.fill"),
        Category(id: 9, name: "Groceries", icon: "basket.fill"),
        Category(id: 10, name: "Bills", icon: "doc.plaintext.fill"),
        Category(id: 11, name: "Sports", icon: "tennis.racket"),
        Category(id: 12, name: "Religious", icon: "book.fill"),
        otherCategory
    ]
    
    static let incomeCategories = [
        emptyCategory,
        Category(id: 1, name: "Salary", icon: "dollarsign"),
        Category(id: 2, name: "Gift", icon: "gift.fill"),
        Category(id: 3, name: "Investment", icon: "chart.line.uptrend.xyaxis"),
        Category(id: 4, name: "Interest", icon: "percent"),
        Category(id: 5, name: "Cashback", icon: "arrow.counterclockwise"),
        Category(id: 6, name: "Bonus", icon: "rosette"),
        otherCategory
    ]
    
    static func getCategoryById(categoryId: Int, transactionType: TransactionType) -> Category {
        if transactionType == .expense {
            return expenseCategories.first { $0.id == categoryId }!
        } else {
            return incomeCategories.first { $0.id == categoryId }!
        }
    }
}
