//
//  APIFetch.swift
//  SampleProject
//
//  Created by Xidi on 2022/2/2.
//

import Foundation
import Alamofire

class APIFetch<T: Codable> {
    // MARK: Internal

    let parser = APIParser<T>()
    
    func request(param: FetchParameters, specialEncoding: ParameterEncoding? = nil, handler: ((Swift.Result<T, AppError>) -> Void)?) {
        let url = URLProcess.encode(url: param.url)
        let encoding = specialEncoding == nil ? getParameterEncoding(method: param.method) : specialEncoding!
        
        Alamofire.request(url, method: param.method, parameters: param.parameters, encoding: encoding, headers: param.header).responseJSON { rsp in
            
            if let error = APINetworkError(response: rsp, error: nil) {
                handler?(.failure(.apiNetwork(error)))
                return
            }
            
            switch rsp.result {
            case .success:
                switch self.parser.parse(data: rsp.data) {
                case .success(let value):
                    handler?(.success(value))
                case .failure(let error):
                    handler?(.failure(.parse(error)))
                }
            case .failure(let error):
                if let e = NetworkError(response: rsp, error: error) {
                    handler?(.failure(.network(e)))
                } else {
                    handler?(.failure(.NSError(error)))
                }
            }
        }
    }
    
    private func getParameterEncoding(method: HTTPMethod) -> ParameterEncoding{
        switch method {
        case .get:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

class APIParser<T: Codable> {
    
    func parse(data: Data?) -> Swift.Result<T, ParseError> {
        guard let data = data else { return .failure(ParseError.emptyData)}
        
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return .success(data)
        } catch {
            return .failure(ParseError.parseJSONError(error))
        }
    }
    
    func stringDecodable(source: String, encoding: String.Encoding = .utf8) -> T? {
        let result = self.parse(data: source.data(using: encoding))
        
        switch result {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
    
}
