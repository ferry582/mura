//
//  DetailTransactionViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 16/01/24.
//

import Foundation
import RxSwift

class DetailTransactionViewModel {
    private let useCase = TransactionInjection().getDetailTransactionUseCase()
    private let _transactionChanged = PublishSubject<Void>()
    private let _error = PublishSubject<Error>()
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    
    var transactionChanged: Observable<Void> {
        return _transactionChanged.asObservable()
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    
    func updateTransaction(old: Transaction, new: inout Transaction) async {
        _isLoading.onNext(true)
        
        do {
            new.amount = new.type == .expense ? (new.amount * -1) : new.amount // Make amount negative if expense type
            
            // Transaction data validation
            try ValidatorFactory.validatorFor(type: .category).validated(new.category.name)
            try ValidatorFactory.validatorFor(type: .requiredField(field: "Amount")).validated(new.amount)
            try ValidatorFactory.validatorFor(type: .allowUpdateTransaction(oldTransaction: old)).validated(new)
            
            let result = await useCase.updateTransaction(id: old.id, newTransaction: new)
            switch result {
            case .success:
                _transactionChanged.onNext(())
            case .failure(let error):
                _error.onNext(error)
            }
        } catch {
            _error.onNext(error)
        }
        
        _isLoading.onNext(false)
    }
    
    func deleteTransaction(id: UUID) async {
        _isLoading.onNext(true)
        
        let result = await useCase.deleteTransaction(id: id)
        switch result {
        case .success:
            _transactionChanged.onNext(())
        case .failure(let error):
            _error.onNext(error)
        }
        
        _isLoading.onNext(false)
    }
}
