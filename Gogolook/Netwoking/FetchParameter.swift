//
//  FetchParameter.swift
//  SampleProject
//
//  Created by Xidi on 2022/2/2.
//

import Foundation
import Alamofire

class FetchParameters {
    // MARK: Lifecycle

    init(url: String, parameters: [String: Any]?, method: HTTPMethod) {
        self.url = url
        self.parameters = parameters
        self.method = method
        header = [:]

        defaultHeader()
    }

    // MARK: Internal

    var url: String
    var parameters: [String: Any]?
    var method: HTTPMethod
    var header: HTTPHeaders

    func defaultHeader() {
        header["Content-Type"] = "application/x-www-form-urlencoded"
        header["Accept"] = "application/json"
    }
    
    func jsonHeader(){
        header["Content-Type"] = "application/json"
        header["Accept"] = "application/json"
    }

    func authHeader(token: String) {
        print("token = \(token)")
        header["Authorization"] = token
    }
    
    func textHeader() {
        header["Accept"] = "text/plain, text/html"
    }
}
