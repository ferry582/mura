//
//  TransactionRepository.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

protocol TransactionRepository {
    func getTransactions(startDate: Date, endDate: Date) async throws -> [Transaction]
//     func getTransaction(id: UUID) async -> Result<Transaction? , TransactionError>
//     func deleteTransaction(_ id: UUID) async -> Result<Bool, TransactionError>
    func createTransaction(_ transaction: Transaction) async throws -> ()
//     func updateTransaction(_ transaction: Transaction) async -> Result<Bool, TransactionError>
}
