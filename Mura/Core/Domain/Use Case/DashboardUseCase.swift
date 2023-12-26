//
//  DashboardUseCase.swift
//  Mura
//
//  Created by Ferry Dwianta P on 20/12/23.
//

import Foundation

protocol DashboardUseCase {
    func getTransactions(startDate: Date, endDate: Date) async -> Result<[Transaction], Error>
}

struct DashboardUseCaseImpl: DashboardUseCase {
    let repository: TransactionRepository
    
    func getTransactions(startDate: Date, endDate: Date) async -> Result<[Transaction], Error> {
        do {
            let transactions =  try await repository.getTransactions(startDate: startDate, endDate: endDate)
            return .success(transactions)
        } catch {
            return .failure(error)
        }
    }
    
}
