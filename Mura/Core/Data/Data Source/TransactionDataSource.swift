//
//  TransactionDataSource.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

protocol TransactionDataSource {
    func getAll() async throws -> [Transaction]
//    func getById(_ id: UUID) async throws -> Transaction?
//    func delete(_ id: UUID) async throws -> ()
    func create(transaction: Transaction) async throws -> ()
//    func update(id: UUID, transaction: Transaction) async throws -> ()
}
