//
//  ReportViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 27/01/24.
//

import UIKit
import RxSwift

class ReportViewModel {
    private let useCase = TransactionInjection().getDashboardUseCase()
    private let _totalBalanceText = BehaviorSubject<String>(value: "0.00")
    private let _balancePercentageChangeText = BehaviorSubject<NSAttributedString>(value: NSAttributedString(string: "0%"))
    private let _expenseAmountText = BehaviorSubject<String>(value: "0.00")
    private let _incomeAmountText = BehaviorSubject<String>(value: "0.00")
    private let _error = PublishSubject<Error>()
    
    var totalBalanceText: Observable<String> {
        return _totalBalanceText.asObservable()
    }
    var balancePercentageText: Observable<NSAttributedString> {
        return _balancePercentageChangeText.asObservable()
    }
    var expenseAmountText: Observable<String> {
        return _expenseAmountText.asObservable()
    }
    var incomeAmountText: Observable<String> {
        return _incomeAmountText.asObservable()
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    
    func updateReportInfo(with groupedTransactions: [GroupedTransaction], in selectedMonthYear: Date) async {
        var totalBalance: Double = 0
        var totalExpense: Double = 0
        var totalIncome: Double = 0
        
        for groupedTransaction in groupedTransactions {
            totalBalance += groupedTransaction.header.totalAmount
            
            for transaction in groupedTransaction.items {
                if transaction.type == .expense {
                    totalExpense += transaction.amount
                } else {
                    totalIncome += transaction.amount
                }
            }
        }
        
        _totalBalanceText.onNext(totalBalance.formatToLocalizedDecimal())
        _expenseAmountText.onNext(abs(totalExpense).formatToLocalizedDecimal())
        _incomeAmountText.onNext(totalIncome.formatToLocalizedDecimal())
        
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonthYear)!
        let previousMonthTransactions = await useCase.getTransactions(startDate: previousMonth.firstDayofMonth(), endDate: previousMonth.lastDayofMonth())
        
        switch previousMonthTransactions {
        case .success(let transactions):
            var previousMonthTotalBalance: Double = 0
            for transaction in transactions {
                previousMonthTotalBalance += transaction.amount
            }
            
            _balancePercentageChangeText.onNext(
                getPercentageChangeAttributed(
                    previousBalance: previousMonthTotalBalance,
                    currentBalance: totalBalance,
                    previousMonth: previousMonth.convertToMonthNameString().lowercased(),
                    isCurrentTransactionsEmpty: groupedTransactions.isEmpty
                )
            )
        case .failure(let error):
            _error.onNext(error)
        }
    }
    
    private func getPercentageChangeAttributed(previousBalance: Double, currentBalance: Double, previousMonth: String, isCurrentTransactionsEmpty: Bool) -> NSMutableAttributedString {
        var percentChangeStr = ""
        var iconImage = UIImage()
        var attributeColor = UIColor()
        
        if isCurrentTransactionsEmpty {
            iconImage = UIImage(named: "ChartPositiveIcon")!
            percentChangeStr = "-"
            attributeColor = UIColor.textSecondary
        } else if previousBalance == 0 {
            if currentBalance > 0 {
                iconImage = UIImage(named: "ChartPositiveIcon")!
                percentChangeStr = "Increase"
                attributeColor = UIColor.main
            } else if currentBalance < 0 {
                iconImage = UIImage(named: "ChartNegativeIcon")!
                percentChangeStr = "Decrease"
                attributeColor = UIColor.negativeAmount
            } else {
                iconImage = UIImage(named: "ChartPositiveIcon")!
                percentChangeStr = "0%"
                attributeColor = UIColor.textSecondary
            }
        } else {
            let percentChange = ((currentBalance - previousBalance) / abs(previousBalance)) * 100
            percentChangeStr = "\(String(format: "%.1f", percentChange))%"
            
            if percentChange == 0 {
                iconImage = UIImage(named: "ChartPositiveIcon")!
                attributeColor = UIColor.textSecondary
            } else if percentChange >= 0 {
                iconImage = UIImage(named: "ChartPositiveIcon")!
                attributeColor = UIColor.main
            } else {
                iconImage = UIImage(named: "ChartNegativeIcon")!
                attributeColor = UIColor.negativeAmount
            }
        }
        
        let text = NSMutableAttributedString()
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = iconImage.withTintColor(attributeColor, renderingMode: .alwaysOriginal)
        iconAttachment.bounds = CGRect(x: 0, y: 1, width: iconImage.size.width, height: iconImage.size.height)
        let iconString = NSAttributedString(attachment: iconAttachment)
        
        text.append(iconString)
        text.append(NSAttributedString(string: "  \(percentChangeStr) ", attributes: [
            NSAttributedString.Key.foregroundColor: attributeColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]))
        text.append(NSAttributedString(string: "from \(previousMonth)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.textSecondary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]))
        
        return text
    }
}
