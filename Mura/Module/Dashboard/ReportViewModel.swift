//
//  ReportViewModel.swift
//  Mura
//
//  Created by Ferry Dwianta P on 27/09/23.
//

import UIKit

class ReportViewModel {
    func getBalancePercentText() -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "30% ", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.main,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]))
        text.append(NSAttributedString(string: "from february", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.textSecondary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]))
        return text
    }
}
