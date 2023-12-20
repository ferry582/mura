//
//  DashboardViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 19/12/23.
//

import Foundation
import RxSwift
import RxRelay

struct TransactionSection {
    let date: Date
    var totalAmount: Double
    var transactions: [Transaction]
}

class DashboardViewModel {
    
    private let useCase = TransactionInjection().getDashboardUseCase()
    private let transactionSectionSubject = BehaviorSubject<[TransactionSection]>(value: [])
    private let errorSubject = BehaviorSubject<Error?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var transactionSections: Observable<[TransactionSection]> {
        transactionSectionSubject.asObserver()
    }
    var error: Observable<Error?> {
        return errorSubject.asObserver()
    }
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    func getTransactions() async {
        isLoadingRelay.accept(true)
        
        let result = await useCase.getTransactions()
        switch result {
        case .success(let transactions):
            mapToTransactionSections(transactions: transactions)
        case .failure(let error):
            errorSubject.onNext(error)
        }
        
        isLoadingRelay.accept(false)
    }
    
    func mapToTransactionSections(transactions: [Transaction]) {
        var transactionSections: [TransactionSection] = []

        // Iterate through transactions and group them by date
        for transaction in transactions {
            let sectionDate = Calendar.current.startOfDay(for: transaction.date)

            if let index = transactionSections.firstIndex(where: { $0.date == sectionDate }) {
                transactionSections[index].transactions.append(transaction)
                transactionSections[index].totalAmount += transaction.amount
            } else {
                let newSection = TransactionSection(date: sectionDate, totalAmount: transaction.amount, transactions: [transaction])
                transactionSections.append(newSection)
            }
        }
        transactionSectionSubject.onNext(transactionSections)
    }

}
