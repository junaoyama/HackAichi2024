//
//  SQLite3DataFormatter.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation

struct SQLite3DataFormatter {
    static func convert(from date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // SQLiteの日時フォーマットに合わせる
        if let sentAtDate = dateFormatter.date(from: date) {
            return sentAtDate
        } else {
            return nil
        }
    }
    
    static func convert(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  // SQLiteの日時フォーマットに合わせる
        return dateFormatter.string(from: date)
    }
}
