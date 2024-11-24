//
//  DateFormatter.swift
//  SplitBill
//
//  Created by Marsha Likorawung on 23/10/24.
//
import Foundation

extension DateFormatter {
    static var dateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    static func dateFormatterYearComma(_ date: Date) -> String{
        let dateFormat = "MMMM dd, yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    static func parseFormattedDate(_ formattedDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"

        return formatter.date(from: formattedDate)
    }
}
