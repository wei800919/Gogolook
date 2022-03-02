//
//  Errors.swift
//  SampleProject
//
//  Created by Xidi on 2022/2/2.
//

import Foundation

import Foundation
import Alamofire

public struct ErrorDescription: LocalizedError, Equatable {
    private let description: String
    
    public init(description: String) {
        self.description = description
    }
    
    public var localizedDescription: String {
        return description
    }
}

extension ErrorDescription: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.description = value
    }
}

public struct SomeError: Swift.Error, Equatable {
    public static func ==(lhs: SomeError, rhs: SomeError) -> Bool {
        return true
    }
}

protocol APIError: Codable {
    var Error: ErrorCodable? { get set }
}

public struct APINetworkError: Error {
    
    private(set) var HTTPRequestURL: String?
    private(set) var httpBody: String?
    
    private(set) var status: String?
    private(set) var title: String?
    private(set) var detail: String?
    private(set) var mulitiDetail: String?
    
    /// HTTP status code // 200, 300 , 400, 500
    let statusCode: Int?
    
    private(set) var message: String = ""
    
    init? (response: Alamofire.DataResponse<Any>?, error: Error?) {

        if let statusCode = response?.response?.statusCode, statusCode >= 200, statusCode < 300, error == nil {
            return nil
        }
        
        self.HTTPRequestURL = response?.request?.url?.absoluteString
        
        if let httpBody = response?.request?.httpBody {
            self.httpBody = String(decoding: httpBody, as: UTF8.self)
        }
        
        self.statusCode = response?.response?.statusCode
        
        if let statusCode = self.statusCode {
            self.message = getStatusCodeMessage(HTTPStatusCode: statusCode)
        }
        
        guard let rsp = response else { return nil }
        
        switch parse(data: rsp.data) {
        case .success(let value):
            guard let e = value.Error else { return nil }
            
            self.status = e.Status
            self.title = e.Title
            self.detail = e.Detail
            self.mulitiDetail = e.MulitiDetail
        case .failure(_):
            return nil
        }
    }
    
    public var localizedDescription: String { message }
    
    private func getStatusCodeMessage(HTTPStatusCode: Int) -> String {
        switch HTTPStatusCode {
        case 400, 401, 403, 500, 502, 503:
            return "Server error"
        case 404, 498:
            return "Not Found"
        case 408, 504:
            return "Timeout"
        case 499:
            return "Network wrong"
        default:
            return "Unexpected error"
        }
    }
    
    private func parse(data: Data?) -> Swift.Result<ServerErrorCodable, ParseError> {
        guard let data = data else { return .failure(ParseError.emptyData)}
        
        do {
            let data = try JSONDecoder().decode(ServerErrorCodable.self, from: data)
            return .success(data)
        } catch {
            return .failure(ParseError.parseJSONError(error))
        }
    }
}

public enum AppError {
    case network(NetworkError)
    case apiNetwork(APINetworkError)
    case parse(ParseError)
    case api(ErrorCodable)
    case defineError(DefineError)
    case NSError(Error)
    
    var name: String {
        switch self {
        case .network(_):
            return "network"
        case .apiNetwork(_):
            return "APINetwork"
        case .parse(_):
            return "parse"
        case .api(_):
            return "api"
        case .defineError(_):
            return "defineError"
        case .NSError(_):
            return "NSError"
        }
    }
}

extension AppError: Error {
    
    public var localizedDescription: String {
        switch self {
        case .network(let value):
            return value.localizedDescription
        case .apiNetwork(let value):
            return value.localizedDescription
        case .parse(let value):
            return value.localizedDescription
        case .api(let value):
            return value.localizedDescription
        case .defineError(let value):
            return value.rawValue
        case .NSError(let value):
            return value.localizedDescription
        }
    }
    
}

extension AppError: Equatable {
    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch lhs {
        case .defineError(let e):
            switch rhs {
            case .defineError(let v):
                if e.rawValue == v.rawValue {
                    return true
                }
            default:
                ()
            }
        default:
            ()
        }
        return false
    }
}

public struct NetworkError: Error {
    /// foundation NSError code
    let code: Int?
    
    /// HTTP status code // 200, 300 , 400, 500
    let statusCode: Int?
    
    private(set) var message: String = ""
    private(set) var alamofireError: AFError?
    
    init? (response: Alamofire.DataResponse<Any>?, error: Error?) {

        if let statusCode = response?.response?.statusCode, statusCode >= 200, statusCode < 300, error == nil {
            return nil
        }
        
        self.code = (error as NSError?)?.code
        self.statusCode = response?.response?.statusCode
        
        if let statusCode = self.statusCode {
            self.message = NetworkError.getStatusCodeMessage(HTTPStatusCode: statusCode)
        }
        
        // statusCode 200 還是有可能是 Alamofire error
        if let err = error as? Alamofire.AFError {
            self.alamofireError = err
            
            switch err {
            case .responseSerializationFailed:
                self.message = "inputDataNilOrZeroLength"
            default:
                ()
            }
        } else { // NSError
            switch self.code {
            case NSURLErrorNotConnectedToInternet: // -1009
                self.message = "NSURLErrorNotConnectedToInternet"
            default:
                ()
            }
        }
    }
    
    public var localizedDescription: String {
        return message
    }
    
    static func getStatusCodeMessage(HTTPStatusCode: Int) -> String {
        switch HTTPStatusCode {
        case 400, 401, 403, 500, 502, 503:
            return "Server error"
        case 404, 498:
            return "Not Found"
        case 408, 504:
            return "Timeout"
        case 499:
            return "Network wrong"
        default:
            return "Unexpected error"
        }
    }
}

public enum ParseError: LocalizedError {
    case emptyData
    case parseJSONError(Swift.Error)
    
    public var localizedDescription: String {
        switch self {
        case .emptyData:
            return "Data is Empty"
        case let .parseJSONError(error):
            if let error = error as? Swift.DecodingError {
                switch error {
                case .keyNotFound(let key, let context):
                    return "KeyNotFound: \(key), \(context)"
                case .typeMismatch(_, let context):
                    return "TypeMismatch: \(context)"
                case .valueNotFound(_, let context):
                    return "ValueNotFound: \(context)"
                case .dataCorrupted(let context):
                    return "DataCorrupted: \(context)"
                default:
                    return "decodingError"
                }
            }
            return error.localizedDescription
        }
    }
}

public struct ErrorCodable: Codable {
    let Status: String?
    let Title: String?
    let Detail: String?
    let MulitiDetail: String?
}

extension ErrorCodable: Error {
    public var localizedDescription: String {
        return "\(Title ?? "") \(Detail ?? "") \(MulitiDetail ?? "")"
    }
}

public struct ServerErrorCodable: Codable {
    
    var Meta: MetaCodable?
    var Error: ErrorCodable?
}

public struct MetaCodable: Codable {
    var HttpStatusCode: String?
    var PageSize: Int?
    var PageCount: Int?
    var PageNumber: Int?
}

public enum DefineError: String, Equatable {
    case ApnsTokenEmpty
}
