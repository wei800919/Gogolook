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
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(self.viewModel.subTypes.count)
        return component == 0 ? 2 : self.viewModel.subTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerView = pickerView as? TypesPickerView else {
            return ""
        }
        if component == 0 {
            return pickerView.setupMainType(row: row)
        }
        else {
            return pickerView.setupSubType(subTypes: viewModel.subTypes, row: row)
        }
    }
    
}
