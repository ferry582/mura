//
//  TransactionInjection.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

class TransactionInjection {
    private func getRepo() -> TransactionRepository {
        let dataSource = TransactionCoreDataSourceImpl.shared
        return TransactionRepositoryImpl.shared(dataSource)
    }
    
    func getAddTransactionUseCase() -> AddTransactionUseCase {
        return AddTransactionUseCaseImpl(repository: getRepo())
    }
    
    func getDashboardUseCase() -> DashboardUseCase {
        return DashboardUseCaseImpl(repository: getRepo())
    }
    
    func getDetailTransactionUseCase() -> DetailTransactionUseCase {
        return DetailTransactionUseCaseImpl(repository: getRepo())
    }
}
