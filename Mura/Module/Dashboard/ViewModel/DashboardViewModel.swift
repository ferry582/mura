//
//  DashboardViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 19/12/23.
//

import UIKit
import RxSwift
import RxRelay

class DashboardViewModel {
    private let useCase = TransactionInjection().getDashboardUseCase()
    private let _groupedTransactions = BehaviorSubject<[GroupedTransaction]>(value: [])
    private let _error = PublishSubject<Error>()
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    
    var groupedTransactions: Observable<[GroupedTransaction]> {
        _groupedTransactions.asObservable()
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    func getTransactions(in selectedMonthYear: Date) async {
        _isLoading.onNext(true)
        
        let result = await useCase.getTransactions(startDate: selectedMonthYear.firstDayofMonth(), endDate: selectedMonthYear.lastDayofMonth())
        switch result {
        case .success(let transactions):
            let groupedTransactions = mapToTransactionSections(transactions: transactions)
            _groupedTransactions.onNext(groupedTransactions)
        case .failure(let error):
            _error.onNext(error)
        }
        
        _isLoading.onNext(false)
    }
    
    private func mapToTransactionSections(transactions: [Transaction]) -> [GroupedTransaction] {
        var transactionSections: [GroupedTransaction] = []
        
        // Group transactions by date
        for transaction in transactions {
            let sectionDate = Calendar.current.startOfDay(for: transaction.date)
            
            if let index = transactionSections.firstIndex(where: { $0.header.date == sectionDate }) {
                transactionSections[index].items.append(transaction)
                transactionSections[index].header.totalAmount += transaction.amount
            } else {
                let newSection = GroupedTransaction(header: SectionHeader(date: sectionDate, totalAmount: transaction.amount), items: [transaction])
                transactionSections.append(newSection)
            }
        }
        return transactionSections
    }
}

