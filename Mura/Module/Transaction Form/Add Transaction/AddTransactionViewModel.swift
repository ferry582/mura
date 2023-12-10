//
//  AddTransactionViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 08/12/23.
//

import Foundation

class AddTransactionViewModel {
    
    private let useCase = TransactionInjection().getAddTransactionUseCase()
    
    func createTransaction(data: Transaction) async {
        let result = await useCase.createTransaction(data)
        switch result {
        case .success(_):
            print("simpan berhasil")
        case .failure(_):
            print("simpan gagal")
        }
        // note bikin UI State, jadi kalau success maka loading stop dan lanjutin task, tapi kalau error atau masuk di .failure loading stop tapi show atau print error.
    }
}
