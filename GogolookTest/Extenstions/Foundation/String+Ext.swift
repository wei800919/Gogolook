//
//  String+Ext.swift
//  GogolookTest
//
//  Created by Xidi on 2022/3/2.
//

import Foundation

extension String {
    func stringFromDate(orignFormatter: String = "MM yyyy", timeZone: String = "UTC", newFormatterString: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: timeZone)
        formatter.dateFormat = orignFormatter
        formatter.locale = Locale(identifier: "en_us")
        
        guard let date = formatter.date(from: self) else { return self }
        
        formatter.dateFormat = newFormatterString
        return formatter.string(from: date)
    }
    
    func checkDateStringFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM yyyy"
        if let _ = dateFormatter.date(from: self) {
            return dateFormatter.dateFormat
        }
        else if let _ = dateFormatter.date(from: self) {
            return dateFormatter.dateFormat
        }
        
        return ""
    }
}
