//
//  APIFetch.swift
//  GogolookTestTests
//
//  Created by Xidi on 2022/2/28.
//

import XCTest
@testable import GogolookTest

class APIFetchTest: XCTestCase {

    func testAPIFetch() throws{
        let process = APIFetch<TopModelCodable>()
        let param: [String: Any] = [:]
        
        process.request(param: FetchParameters(url: API.shared.getAnimeUrl(page: "1"), parameters: param, method: .get)) { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value.top?.count != 0)
                print(value as Any)
            case .failure(_):
                XCTFail()
            }
        }
    }

}
