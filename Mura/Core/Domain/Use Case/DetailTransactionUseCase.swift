//
//  DetailTransactionUseCase.swift
//  Mura
//
//  Created by Ferry Dwianta P on 25/01/24.
//

import Foundation

protocol DetailTransactionUseCase {
    func updateTransaction(id: UUID, newTransaction: Transaction) async -> Result<Void, Error>
    func deleteTransaction(id: UUID) async -> Result<Void, Error>
}

struct DetailTransactionUseCaseImpl: DetailTransactionUseCase {
    let repository: TransactionRepository

    func updateTransaction(id: UUID, newTransaction: Transaction) async -> Result<Void, Error> {
        do {
            try await repository.updateTransaction(id: id, newTransaction: newTransaction)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteTransaction(id: UUID) async -> Result<Void, Error> {
        do {
            try await repository.deleteTransaction(id: id)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
