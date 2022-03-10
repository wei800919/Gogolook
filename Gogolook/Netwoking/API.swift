//
//  API.swift
//  SampleProject
//
//  Created by Xidi on 2022/2/2.
//

import Foundation

class API {
    private init() {}

    static let shared = API()

    private func getBaseSearchURL() -> String {
        return "https://api.jikan.moe/v3/top/%@/%@/%@"
    }
}

extension API {
    func getAnimeUrl(mainType: String, subType: String, page: String) -> String {
        String(format: getBaseSearchURL(), mainType, page, subType)
    }
}
