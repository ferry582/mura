//
//  TransactionFormValidators.swift
//  Mura
//
//  Created by Ferry Dwianta P on 11/12/23.
//

import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: Any?) throws
}

enum ValidatorType {
    case category
    case requiredField(field: String)
    case allowUpdateTransaction(oldTransaction: Transaction)
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .category:
            return CategoryValidator()
        case .requiredField(field: let fieldName):
            return RequiredFieldValidator(fieldName)
        case .allowUpdateTransaction(oldTransaction: let oldTransaction):
            return AllowUpdateValidator(oldTransaction: oldTransaction)
        }
    }
    
    struct CategoryValidator: ValidatorConvertible {
        func validated(_ value: Any?) throws {
            guard value as? String != "None" else {
                throw ValidationError("Category is not selected yet" )
            }
        }
    }
    
    struct RequiredFieldValidator: ValidatorConvertible {
        private let fieldName: String
        
        init(_ field: String) {
            fieldName = field
        }
        
        func validated(_ value: Any?) throws {
            guard let value else {
                throw ValidationError("Required field " + fieldName)
            }
            guard value as? String != "" else {
                throw ValidationError("Required field " + fieldName)
            }
            guard value as? Double != 0 else {
                throw ValidationError("Required field " + fieldName)
            }
        }
    }
    
    struct AllowUpdateValidator: ValidatorConvertible {
        private let oldTransaction: Transaction
        
        init(oldTransaction: Transaction) {
            self.oldTransaction = oldTransaction
        }
        
        func validated(_ value: Any?) throws {
            if let value = value as? Transaction {
                if oldTransaction.date == value.date &&
                    oldTransaction.category == value.category &&
                    oldTransaction.note == value.note &&
                    oldTransaction.amount == value.amount &&
                    oldTransaction.type == value.type {
                    throw ValidationError("There is no changes!")
                }
            }
        }
    }
}
