//
//  GroupedTransaction.swift
//  Mura
//
//  Created by Ferry Dwianta P on 27/01/24.
//

import Foundation
import RxDataSources

struct GroupedTransaction {
    var header: SectionHeader
    var items: [Transaction]
}

struct SectionHeader {
    let date: Date
    var totalAmount: Double
}

extension GroupedTransaction: SectionModelType {
    init(original: GroupedTransaction, items: [Transaction]) {
        self = original
        self.items = items
    }
}
