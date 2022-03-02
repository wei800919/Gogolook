//
//  DateStringFormatTest.swift
//  GogolookTest
//
//  Created by Xidi on 2022/3/2.
//

import XCTest
import GogolookTestTests

class DateStringFormatTest: XCTestCase {

    func testDateStringTransfer() {
        var dateString = "Apr 2022"
        dateString = dateString.stringFromDate(newFormatterString: "yyyy")
        XCTAssertEqual(dateString, "2022")
    }
}
