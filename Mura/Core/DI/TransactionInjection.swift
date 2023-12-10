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
        let repo = getRepo()
        return AddTransactionUseCaseImpl(repository: repo)
    }
}
