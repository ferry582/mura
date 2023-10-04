//
//  Date+Ext.swift
//  Mura
//
//  Created by Ferry Dwianta P on 29/09/23.
//

import Foundation

extension Date {
    func convertToMonthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        return dateFormatter.string(from: self)
    }
}
