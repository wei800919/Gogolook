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
    var filterTop = [TopCodable]()
    var subTypeArray = [String]()
    var favorites = [Int]() // for anmie
    var mangaFavorites = [Int]() // for manga
    var mainType: String = MainTypes.anime.rawValue
    var animeSubType = "upcoming"
    var mangaSubType = ""
    var page = 1
    var isFilter = false
    var needToUpdateSubType = false
    
    var onRequestEnd: (() -> Void)?
    var onDoneRequestEnd: (() -> Void)?
    var onFilterRequestEnd: (() -> Void)?
    var onLoadMoreRequestEnd: (() -> Void)?
    var onRequestError: ((AppError) -> Void)?
    
    func setup() {
        if let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] {
            self.favorites = favorites
        }
        
        if let mangaFavorites = UserDefaults.standard.object(forKey: "mangaFavorites") as? [Int] {
            self.mangaFavorites = mangaFavorites
        }
    }
    
    func getSubType() -> String {
        return mainType == MainTypes.anime.rawValue ? animeSubType : mangaSubType
    }
    
    func isAnimeType() -> Bool {
        return mainType == MainTypes.anime.rawValue
    }
    
    func isMangaType() -> Bool {
        return mainType == MainTypes.manga.rawValue
    }
    
    func fetchAnimeList(mainType: String , isLoadMore: Bool = false, isDone: Bool = false) {
        var subType = self.isAnimeType() ? animeSubType : mangaSubType
        
        if isFilter {
            subType = self.isAnimeType() ? "upcoming" : ""
        }
        
        manager.fetchAnimeList(mainType: mainType, subType: subType, page: "\(self.page)") { [weak self] result in
            switch result {
            case .success(let topList):
                if let data = topList.top {
                    if isLoadMore {
                        self?.top += data
                        if self?.isFilter == true {
                            self?.onFilterRequestEnd?()
                            return
                        }
                    }
                    else {
                        self?.top = data
                    }
                    if self?.needToUpdateSubType == true || self?.subTypeArray.count == 0 {
                        self?.needToUpdateSubType = false
                        var set = Set<String>()
                        self?.top.forEach({ top in
                            set.insert(top.type!)
                        })
                        
                        self?.subTypeArray = Array(set)
                        if self?.isAnimeType() == true {
                            self?.subTypeArray.insert("upcoming", at: 0)
                        }
                        print(self?.subTypeArray)
                    }
                    
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
                else if let error = topList.error {
                    self?.onRequestError?(.api(ErrorCodable(Status: "", Title: "", Detail: error, MulitiDetail: "")))
                }
                else if let status = topList.status, let message = topList.message {
                    self?.onRequestError?(.api(ErrorCodable(Status: "\(status)", Title: "", Detail: message, MulitiDetail: "")))
                }
                break
            case .failure(let error):
                self?.onRequestError?(error)
                break
            }
        }
    }
}
