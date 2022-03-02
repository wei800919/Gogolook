//
//  URLProcess.swift
//  SampleProject
//
//  Created by Xidi on 2022/2/2.
//

import Foundation

class URLProcess {
    public static func encode(url: String) -> String {
        var result: String = ""

        if url.contains("#"), url.firstIndex(of: "#") != nil {
            result = String(url.prefix(upTo: url.firstIndex(of: "#")!))
        } else {
            result = url
        }

        if let resultStr = result.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            result = resultStr.replacingOccurrences(of: "+", with: "%2B")
        }

        return result
    }

    public static func decode(str: String?) -> String {
        var result = str?.removingPercentEncoding ?? ""
        result = result.replacingOccurrences(of: "+", with: " ")
        return result
    }
}
