//
//  TopModel.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import Foundation

struct AnimeCodable: Codable, APIError {
    var Error: ErrorCodable?
//    var request_hash: String?
//    var request_cached: String?
//    var request_cache_expiry: Int?
//    var API_DEPRECATION: Bool?
//    var API_DEPRECATION_DATE: String?
//    var API_DEPRECATION_INFO: String?
    var top: [TopCodable]?
}

struct TopCodable: Codable{
    var mal_id: Int?
    var rank: Int?
    var title: String?
    var url: String?
    var image_url: String?
    var type: String?
    var episodes: Int?
    var start_date: String?
    var end_date: String?
    var members: Int?
    var score: Int?
}
