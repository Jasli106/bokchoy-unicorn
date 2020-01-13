//
//  DateExtensions.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/25/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//
//  This file is for extensions relating to date and time stuff (formatting, retrieving, etc.)

import Foundation
import UIKit

extension Date {
    static func calculateDate(day: Int, month: Int, year: Int, hour: Int, minute: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let calculatedDate = formatter.date(from: "\(month)/\(day)/\(year) \(hour):\(minute)")
        return calculatedDate!
    }
    
    func getDateTime() -> (day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        
        return(day, month, year, hour, minute)
    }
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        print(fromDate)
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        print("DATE: \(date)")
        return date
    }
    
    /*func convertTimeZone (initTimeZone: TimeZone, finalTimeZone: TimeZone) -> Date? {
    }*/
}


