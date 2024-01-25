//
//  TransactionRepository.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

protocol TransactionRepository {
    func getTransactions(startDate: Date, endDate: Date) async throws -> [Transaction]
    func deleteTransaction(id: UUID) async throws -> ()
    func createTransaction(_ transaction: Transaction) async throws -> ()
    func updateTransaction(id: UUID, newTransaction: Transaction) async throws -> ()
}
