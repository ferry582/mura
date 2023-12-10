//
//  AddTransactionUseCase.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

enum TransactionError: Error{
 case DataSourceError, CreateError, DeleteError, UpdateError, FetchError
}

protocol AddTransactionUseCase {
    func createTransaction(_ transaction: Transaction) async -> Result<Bool, TransactionError>
}

struct AddTransactionUseCaseImpl: AddTransactionUseCase {
    let repository: TransactionRepository
    
    func createTransaction(_ transaction: Transaction) async -> Result<Bool, TransactionError> {
        do {
            try await repository.createTransaction(transaction)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }
    }
    
}
