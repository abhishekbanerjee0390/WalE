//
//  WALENetworkManager.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 05/04/22.
//

import Foundation

enum WALEError: Error {
    case noData
    case somethingWentWrong
    case serverError
    case decodingError
}

protocol WALEURLSessionProtocol {
    func task(withRequest request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask
}

protocol WALEURLSessionDataTaskProtocol {
    func resume()
}


struct WALENetworkManager {
    let session: WALEURLSessionProtocol
    
    init(with session: WALEURLSessionProtocol) {
        self.session = session
    }
    
    func get<T: Codable>(from url: URL, completion: @escaping (Result<T, WALEError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = session.task(withRequest: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let statusCode = response?.httpStatusCode {
                switch statusCode {
                case 200...299:
                    
                    guard let jsonData = data else {
                        completion(.failure(WALEError.noData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(T.self, from: jsonData)
                        completion(.success(result))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                    
                default:
                    completion(.failure(WALEError.serverError))
                }
            }
        }
        task.resume()
    }
}
