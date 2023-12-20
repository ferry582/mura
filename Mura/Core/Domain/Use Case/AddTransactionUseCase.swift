//
//  AddTransactionUseCase.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

protocol AddTransactionUseCase {
    func createTransaction(_ transaction: Transaction) async -> Result<Void, Error>
}

struct AddTransactionUseCaseImpl: AddTransactionUseCase {
    let repository: TransactionRepository
    
    func createTransaction(_ transaction: Transaction) async -> Result<Void, Error> {
        do {
            try await repository.createTransaction(transaction)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
}
