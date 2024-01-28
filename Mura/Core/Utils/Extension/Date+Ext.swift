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
    
    func convertToDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        return dateFormatter.string(from: self)
    }
    
    func convertToDayNameString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        return dateFormatter.string(from: self)
    }
    
    func convertToMonthNameString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        return dateFormatter.string(from: self)
    }
    
    func firstDayofMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    func lastDayofMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)!.end
    }
}
