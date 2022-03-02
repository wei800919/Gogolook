//
//  DownloadImageTest.swift
//  GogolookTest
//
//  Created by Xidi on 2022/3/2.
//

import XCTest
import GogolookTest

class DownloadImageTest: XCTestCase {
    func testImageDownload() {
        let imageView: UIImageView?
        let cache = NSCache<NSURL, UIImage>()
        if let url = URL(string: "https://cdn.myanimelist.net/images/anime/1484/120884.jpg?s=7145b92007a48f41c9f190fa5c4ebd6b") {
            let testImageView = UIImageView()
            imageView = testImageView
            XCTAssertNotNil(imageView)
        }
    }
}
