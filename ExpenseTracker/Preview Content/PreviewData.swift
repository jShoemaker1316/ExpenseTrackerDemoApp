//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Jonathan Shoemaker on 10/25/22.
//

import Foundation

var transactionPreviewData = Transaction(id: 1, date: "10/24/2022", institution: "Dumb Store", account: "Broke Account", merchant: "Stupid", amount: 25.54, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
