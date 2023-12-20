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
    
    func getTransactions() async throws -> [Transaction] {
        let transactions = try await dataSource.getAll()
        return transactions
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        try await dataSource.create(transaction: transaction)
    }
    
}
