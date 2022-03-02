//
//  APIURLTest.swift
//  GogolookTestTests
//
//  Created by Xidi on 2022/2/28.
//

import XCTest
@testable import GogolookTest

class APIURLTest: XCTestCase {

    func testUrl() throws{
        XCTAssertEqual(API.shared.getAnimeUrl(page: "1"), "https://api.jikan.moe/v3/top/anime/1/upcoming")
    }
}
