//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Jonathan Shoemaker on 10/25/22.
//

import Foundation
import Combine
import Collections

// need to fix transaction list load order and make it load in order of date, add OrderedDIctionary to [String: [Transaction]] and import collections (new library for data structures
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching transactions", error)
                case .finished:
                    print("finished fetching transactions")
                }
                // insert weak self in order to prevent memory leaks when neccesary
            } receiveValue: { [weak self] result in
                self?.transactions = result
                //dump(self?.transactions)
            }
            .store(in: &cancellables)
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
    //grouping values. creating new dictionary whose keys are groupings returned by given closure
        let groupTransactions = TransactionGroup(grouping: transactions) { $0.month }
        return groupTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("accumulateTransactions")
        guard !transactions.isEmpty else { return [] }
        
    //using a date that matches the sample JSON, instead of Date(). this is a demo, not for productions anyways
        let today = "02/17/2022".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter { $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
    // need to create an extension to round the sum to 2 digits and call here
            sum = sum.roundedToTwoDigits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal", dailyTotal, "sum:", sum)
        }
        
        return cumulativeSum
    }
}
