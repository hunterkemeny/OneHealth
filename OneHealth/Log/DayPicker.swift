//
//  DayPicker.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import Foundation

class DayPicker {
    // MARK: - Property
    static var dayMonthYearNum: Int? = 20000
    
    // MARK: - Methods
    static func setDayMonthYearNum(dayMonthYearNum: Int) {
        self.dayMonthYearNum = dayMonthYearNum
    }
    
    static func getDayMonthYearNum() -> Int {
        return self.dayMonthYearNum!
    }
}
