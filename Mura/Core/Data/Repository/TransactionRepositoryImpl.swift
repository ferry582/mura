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
    
    func getTransactions() async -> Result<[Transaction], TransactionError> {
        do{
            let _transactions =  try await dataSource.getAll()
            return .success(_transactions)
        }catch{
            return .failure(.FetchError)
        }
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        try await dataSource.create(transaction: transaction)
    }
    
}
