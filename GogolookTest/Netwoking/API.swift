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
        return "https://api.jikan.moe/v3/top/anime/%@/upcoming"
    }
}

extension API {
    func getAnimeUrl(page: String) -> String {
        String(format: getBaseSearchURL(), page)
    }
}
