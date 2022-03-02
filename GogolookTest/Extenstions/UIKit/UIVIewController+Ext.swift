//
//  UIVIewController+Ext.swift
//  CinnoxProject
//
//  Created by Xidi on 2022/1/27.
//

import Foundation
import UIKit
import MBProgressHUD

var hud = MBProgressHUD.init()

extension UIViewController {
    
    func showLoadingView(title: String = ""){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = String(format: "%@", title)
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = .clear
        hud.show(animated: true)
    }
    
    func hideLoadingView(){
        hud.hide(animated: true)
    }
    
    func showAPIFailAlert(error: AppError) {
        //guard let error = error.error else { return }
        
        var title = "Message"
        var msg = "UserDataReadError"
        
        switch error {
        case .network(let e):
            switch e.code {
            case NSURLErrorNotConnectedToInternet: // -1009
                msg = "NoInternetConnection"
            case NSURLErrorBadServerResponse: // -1011
                msg = "UnknownMistake"
            case NSURLErrorDataNotAllowed:
                ()
            default:
                ()
            }
        case .apiNetwork(let e):
            title = e.title ?? ""
            msg = e.detail ?? ""
        case .api(let e):
            title = e.Title ?? ""
            msg = e.Detail ?? ""
        case .parse(let e):
            msg = e.localizedDescription
        case .NSError(_), .defineError(_):
            ()
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}
