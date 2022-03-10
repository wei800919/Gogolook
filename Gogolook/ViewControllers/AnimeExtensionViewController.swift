//
//  AnimeExtensionViewController.swift
//  Gogolook
//
//  Created by weixin_ke on 2022/3/9.
//

import UIKit

enum MainTypes: String {
    case anime = "anime"
    case manga = "manga"
}

extension AnimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.mainType == MainTypes.anime.rawValue ? 2 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if viewModel.mainType == MainTypes.anime.rawValue {
//            return component == 0 ? 2 : self.viewModel.subTypeArray.count
//        }
//        else {
//            return 0
//        }
        return component == 0 ? 2 : self.viewModel.subTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerView = pickerView as? TypesPickerView else {
            return ""
        }
        if component == 0 {
            return pickerView.setupMainType(row: row)
        }
        else {
            return pickerView.setupSubType(subTypes: viewModel.subTypeArray, row: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.viewModel.mainType = row == 0 ? MainTypes.anime.rawValue : MainTypes.manga.rawValue
            self.viewModel.isFilter = false
            self.viewModel.needToUpdateSubType = true
            if self.viewModel.mainType == MainTypes.anime.rawValue {
                self.viewModel.animeSubType = "upcoming"
            }
            else {
                self.viewModel.mangaSubType = ""
            }
            
            self.activityIndicatorView.startAnimating()
            viewModel.page = 1
            viewModel.fetchAnimeList(mainType: self.viewModel.mainType)
            viewModel.onRequestEnd = {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.animeCollectionView.reloadData()
                    self.typePickerView.reloadComponent(1)
                }
            }
        }
        else {
            self.viewModel.isFilter = true
            if self.viewModel.mainType == MainTypes.anime.rawValue {
                self.viewModel.animeSubType = self.viewModel.subTypeArray[row]
            }
            else {
                self.viewModel.mangaSubType = self.viewModel.subTypeArray[row]
            }
        }
    }
}
