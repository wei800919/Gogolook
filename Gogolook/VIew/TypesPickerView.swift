//
//  TypesPickerView.swift
//  Gogolook
//
//  Created by weixin_ke on 2022/3/9.
//

import UIKit

class TypesPickerView: UIPickerView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupMainType(row: Int) -> String {
        switch row {
        case 0:
            return MainTypes.anime.rawValue
        case 1:
            return MainTypes.manga.rawValue
        default:
            return ""
        }
    }
    
    func setupSubType(subTypes: [String], row: Int) -> String {
        print(subTypes[row])
        return subTypes[row]
    }

}
