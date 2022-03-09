//
//  AnimeViewModel.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import Foundation

class AnimeViewModel {
    
    var manager = AnimeAPIManager()
    var top = [TopCodable]()
    var subTypes = [String]()
    var favorites = [Int]()
    var page = 1
    
    var onRequestEnd: (() -> Void)?
    var onLoadMoreRequestEnd: (() -> Void)?
    var onRequestError: ((AppError) -> Void)?
    
    func setup() {
        if let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] {
            self.favorites = favorites
        }
    }
    
    func fetchAnimeList(isLoadMore: Bool = false) {
        manager.fetchAnimeList(page: "\(self.page)") { [weak self] result in
            switch result {
            case .success(let topList):
                if let data = topList.top {
                    self?.top += data
                    var set = Set<String>()
                    self?.top.forEach({ top in
                        set.insert(top.type!)
                    })
                    self?.subTypes = Array(set)
                    if isLoadMore {
                        self?.onLoadMoreRequestEnd?()
                    }
                    self?.onRequestEnd?()
                }
                break
            case .failure(let error):
                self?.onRequestError?(error)
                break
            }
        }
    }
}
