//
//  DashboardUseCase.swift
//  Mura
//
//  Created by Ferry Dwianta P on 20/12/23.
//

import Foundation

protocol DashboardUseCase {
    func getTransactions() async -> Result<[Transaction], Error>
}

struct DashboardUseCaseImpl: DashboardUseCase {
    let repository: TransactionRepository
    
    func getTransactions() async -> Result<[Transaction], Error> {
        do {
            let transactions =  try await repository.getTransactions()
            return .success(transactions)
        } catch {
            return .failure(error)
        }
    }
    
}
