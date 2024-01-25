//
//  TransactionDataSource.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

protocol TransactionDataSource {
    func getAll(startDate: Date, endDate: Date) async throws -> [Transaction]
    func delete(id: UUID) async throws -> ()
    func create(transaction: Transaction) async throws -> ()
    func update(id: UUID, newTransaction: Transaction) async throws -> ()
}
