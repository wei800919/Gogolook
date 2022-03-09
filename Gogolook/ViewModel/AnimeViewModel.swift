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
    var subTypeArray = [String]()
    var favorites = [Int]()
    var mainType: String = MainTypes.anime.rawValue
    var finalSubType = ""
    var animeSubType = "upcoming"
    var mangaSubType = ""
    var page = 1
    
    var onRequestEnd: (() -> Void)?
    var onDoneRequestEnd: (() -> Void)?
    var onLoadMoreRequestEnd: (() -> Void)?
    var onRequestError: ((AppError) -> Void)?
    
    func setup() {
        if let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] {
            self.favorites = favorites
        }
    }
    
    func fetchAnimeList(mainType: String , isLoadMore: Bool = false, isDone: Bool = false) {
        print("mainType = \(mainType)")
        
        let subType = mainType == MainTypes.anime.rawValue ? animeSubType : mangaSubType
        print("animeSubType = \(animeSubType)")
        print("subType = \(subType)")
        
        manager.fetchAnimeList(mainType: mainType, subType: subType, page: "\(self.page)") { [weak self] result in
            switch result {
            case .success(let topList):
                if let data = topList.top {
                    self?.top += data
                    var set = Set<String>()
                    self?.top.forEach({ top in
                        set.insert(top.type!)
                    })
                    
                    self?.subTypeArray = Array(set)
                    print(self?.subTypeArray)
                    
                    if isLoadMore {
                        self?.onLoadMoreRequestEnd?()
                        return
                    }
                    if isDone {
                        self?.onDoneRequestEnd?()
                        return
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
