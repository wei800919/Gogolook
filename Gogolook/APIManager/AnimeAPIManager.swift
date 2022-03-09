//
//  AnimeAPIManager.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import Foundation

class AnimeAPIManager {
    func fetchAnimeList(mainType: String, subType: String, page: String, handler: ((Swift.Result<AnimeCodable, AppError>) -> Void)?) {
        let param = FetchParameters(url: API.shared.getAnimeUrl(mainType: mainType, subType: subType, page: page), parameters: nil, method: .get)
        fetch(process: APIFetch<AnimeCodable>(), parameters: param) { result in
            handler?(result)
        }
    }
    
    private func fetch<T: APIError>(process: APIFetch<T>, parameters param: FetchParameters, handler: @escaping (Swift.Result<T, AppError>) -> Void) {
        process.request(param: param) { result in
            switch result {
            case .success(let value):
                if let error = value.Error {
                    handler(.failure(.api(error)))
                    return
                }
                
                handler(.success(value))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}


    
    
