//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Jonathan Shoemaker on 10/25/22.
//

import Foundation

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    func getTransactions() {
        
    }
}
