//
//  DashboardViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 19/12/23.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

struct SectionModel {
    var header: SectionHeader
    var items: [Transaction]
}

struct SectionHeader {
    let date: Date
    var totalAmount: Double
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Transaction]) {
        self = original
        self.items = items
    }
}

class DashboardViewModel {
    private let useCase = TransactionInjection().getDashboardUseCase()
    private let _transactionSections = BehaviorSubject<[SectionModel]>(value: [])
    private let _error = PublishSubject<Error>()
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    
    var transactionSections: Observable<[SectionModel]> {
        _transactionSections.asObservable()
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    func getTransactions(in selectedMonthYear: Date) async {
        _isLoading.onNext(true)
        
        let result = await useCase.getTransactions(startDate: firstDayofMonth(for: selectedMonthYear), endDate: lastDayofMonth(for: selectedMonthYear))
        switch result {
        case .success(let transactions):
            let mappedTransactions = mapToTransactionSections(transactions: transactions)
            _transactionSections.onNext(mappedTransactions)
        case .failure(let error):
            _error.onNext(error)
        }
        
        _isLoading.onNext(false)
    }
    
    private func firstDayofMonth(for date: Date) -> Date {
        return Calendar.current.dateInterval(of: .month, for: date)!.start
    }
    
    private func lastDayofMonth(for date: Date) -> Date {
        return Calendar.current.dateInterval(of: .month, for: date)!.end
    }
    
    private func mapToTransactionSections(transactions: [Transaction]) -> [SectionModel] {
        var transactionSections: [SectionModel] = []
        
        // Group transactions by date
        for transaction in transactions {
            let sectionDate = Calendar.current.startOfDay(for: transaction.date)
            
            if let index = transactionSections.firstIndex(where: { $0.header.date == sectionDate }) {
                transactionSections[index].items.append(transaction)
                transactionSections[index].header.totalAmount += transaction.amount
            } else {
                let newSection = SectionModel(header: SectionHeader(date: sectionDate, totalAmount: transaction.amount), items: [transaction])
                transactionSections.append(newSection)
            }
        }
        return transactionSections
    }
    
}

