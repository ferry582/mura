//
//  AddTransactionViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation
import RxSwift
import RxCocoa

class AddTransactionViewModel {
    
    private let useCase = TransactionInjection().getAddTransactionUseCase()
    private let _transactionCreated = PublishSubject<Void>()
    private let _error = PublishSubject<Error>()
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    
    var transactionCreated: Observable<Void> {
        return _transactionCreated.asObservable()
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    func createTransaction(data: inout Transaction) async {
        _isLoading.onNext(true)
        
        do {
            // Transaction data validation
            try ValidatorFactory.validatorFor(type: .category).validated(data.category.name)
            try ValidatorFactory.validatorFor(type: .requiredField(field: "Amount")).validated(data.amount)
            
            data.amount = data.type == .expense ? (data.amount * -1) : data.amount
            
            let result = await useCase.createTransaction(data)
            switch result {
            case .success:
                _transactionCreated.onNext(())
            case .failure(let error):
                _error.onNext(error)
            }
        } catch {
            _error.onNext(error)
        }
        
        _isLoading.onNext(false)
    }
}
