//
//  String+Ext.swift
//  Mura
//
//  Created by Ferry Dwianta P on 21/12/23.
//

import Foundation

extension Double {
    func formatToLocalizedDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
