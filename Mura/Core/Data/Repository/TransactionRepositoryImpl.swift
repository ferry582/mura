//
//  TransactionRepositoryImpl.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

struct TransactionRepositoryImpl: TransactionRepository {
    
    private let dataSource: TransactionDataSource
    static let shared: (TransactionDataSource) -> TransactionRepository = { dataSource in
        return TransactionRepositoryImpl(dataSource: dataSource)
    }
    
    func getTransactions(startDate: Date, endDate: Date) async throws -> [Transaction] {
        let transactions = try await dataSource.getAll(startDate: startDate, endDate: endDate)
        return transactions
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        try await dataSource.create(transaction: transaction)
    }
    
}
