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
    private let transactionCreatedSubject = PublishSubject<Void>()
    private let errorSubject = BehaviorSubject<Error?>(value: nil)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var transactionCreated: Observable<Void> {
        return transactionCreatedSubject.asObserver()
    }
    var error: Observable<Error?> {
        return errorSubject.asObserver()
    }
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    func createTransaction(data: inout Transaction) async {
        isLoadingRelay.accept(true)
        
        do {
            // Transaction data validation
            try ValidatorFactory.validatorFor(type: .category).validated(data.category.name)
            try ValidatorFactory.validatorFor(type: .requiredField(field: "Amount")).validated(data.amount)
            
            data.amount = data.type == .expense ? (data.amount * -1) : data.amount
            
            let result = await useCase.createTransaction(data)
            switch result {
            case .success:
                transactionCreatedSubject.onNext(())
            case .failure(let error):
                errorSubject.onNext(error)
            }
        } catch {
            errorSubject.onNext(error)
        }
        
        isLoadingRelay.accept(false)
    }
}
