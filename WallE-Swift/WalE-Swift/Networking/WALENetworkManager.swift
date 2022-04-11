//
//  WALENetworkManager.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 05/04/22.
//

import Foundation

enum WALEError: String, Error {
    
    case noData = "No Data Received From Server"
    case somethingWentWrong = "Some went wrong. Please try again!"
    case serverError = "Internal Server Error"
    case decodingError = "Response Decoding Error"
}

typealias WALENetworkResponse<T> = (Result<T, WALEError>) -> Void
typealias WALEImageDownloadResponse = (Result<Data, WALEError>) -> Void

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
    
    func get<T: Codable>(from url: URL, completion: @escaping WALENetworkResponse<T>) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = session.task(withRequest: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            let result = parseResponse(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func download(from url: URL, completion: @escaping WALEImageDownloadResponse) {
        
        let task = session.task(withRequest: URLRequest(url: url)) { (data, response, error) in
            let result = parseResponse(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

private extension WALENetworkManager {
    
    func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, WALEError> {
        if let statusCode = response?.httpStatusCode {
            switch statusCode {
            case 200...299:
                guard let jsonData = data else {
                    return .failure(.noData)
                }
                return .success(jsonData)
            default:
                return.failure(.serverError)
            }
        }
        return .failure(.somethingWentWrong)
    }
}
