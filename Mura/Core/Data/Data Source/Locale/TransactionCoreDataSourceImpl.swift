//
//  TransactionCoreDataSourceImpl.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation
import CoreData

struct TransactionCoreDataSourceImpl: TransactionDataSource {
    
    static let shared: TransactionDataSource = TransactionCoreDataSourceImpl()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TransactionDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func getAll() async throws -> [Transaction] {
        let request = TransactionEntity.fetchRequest()
        return try container.viewContext.fetch(request).map { transactionEntity in
            let type = TransactionType(rawValue: transactionEntity.type!) ?? .income
            return Transaction(
                id: transactionEntity.id!,
                date: transactionEntity.date!,
                category: Category.getCategoryById(categoryId: Int(transactionEntity.categoryId), transactionType: type),
                note: transactionEntity.note,
                amount: transactionEntity.amount,
                type: type
            )
        }
    }
    
    func create(transaction: Transaction) async throws {
        let transactionEntity = TransactionEntity(context: container.viewContext)
        transactionEntity.id = transaction.id
        transactionEntity.amount = transaction.amount
        transactionEntity.categoryId = Int16(transaction.category.id)
        transactionEntity.date = transaction.date
        transactionEntity.note = transaction.note
        transactionEntity.type = transaction.type.rawValue
        try saveContext()
    }
    
    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}
