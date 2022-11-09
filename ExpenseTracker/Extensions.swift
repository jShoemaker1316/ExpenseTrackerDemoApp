//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Jonathan Shoemaker on 10/25/22.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

// MARK: Date Formatter
//date formatter are taxing, so static makes sure there is one instance of it. guard it in case it fails with todays date. Basically needing this to parse the dates in our data into a string format
extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        print("Initializing Date formatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else { return Date() }
        
        return parsedDate
    }
}
//need to make Date Strideable for parsing our data for the chart in TransactionListViewModel. also should change how the date data appears
extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double {
    func roundedToTwoDigits() -> Double {
        return (self * 100).rounded() / 100
    }
}
