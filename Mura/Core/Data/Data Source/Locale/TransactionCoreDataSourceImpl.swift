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
            
            // Convert string category data into Category type
            let categoryData = switch Category.categoryFromString(transactionEntity.category ?? "") {
            case .expense(let expenseCategory):
                Category.expense(expenseCategory)
            case .income(let incomeCategory):
                Category.income(incomeCategory)
            default :
                Category.income(.salary)
            }
            
            return Transaction(
                id: transactionEntity.id!,
                date: transactionEntity.date!,
                category: categoryData,
                note: transactionEntity.note,
                amount: transactionEntity.amount,
                type: TransactionType(rawValue: transactionEntity.type!) ?? .income
                )
        }
    }
    
    func create(transaction: Transaction) async throws {
        let transactionEntity = TransactionEntity(context: container.viewContext)
        transactionEntity.id = transaction.id
        transactionEntity.amount = transaction.amount
        transactionEntity.category = switch transaction.category {
        case .income(let incomeCategory):
            incomeCategory.rawValue
        case .expense(let expenseCategory):
            expenseCategory.rawValue
        }
        transactionEntity.date = transaction.date
        transactionEntity.note = transaction.note
        transactionEntity.type = transaction.type.rawValue
        saveContext()
    }
    
     func saveContext(){
        let context = container.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
