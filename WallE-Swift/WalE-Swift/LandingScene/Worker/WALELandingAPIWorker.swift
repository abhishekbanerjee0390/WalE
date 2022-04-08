//
//  WALELandingAPIWorker.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation
 
protocol WALELandingAPIWorkerProtocol {
    
    func requestToGetPictureOfTheDay(forDate dateString: String, completion: @escaping (APOD?) -> Void)
}

struct WALELandingAPIWorker: WALELandingAPIWorkerProtocol {
        
    let networkManager: WALENetworkManager
    init() {
        let config = URLSessionConfiguration.default
        networkManager = WALENetworkManager(with: URLSession(configuration: config))
    }
    
    func requestToGetPictureOfTheDay(forDate dateString: String, completion: @escaping (APOD?) -> Void) {
        
        guard let url = createAPODUrl(forDate: dateString) else {
            debugPrint("requestToGetPictureOfTheDay failed")
            completion(nil)
            return
        }
        networkManager.get(from: url) { (result: Result<APOD,WALEError>) in
            switch result {
            case .success(let apod):
                debugPrint("success", apod)
                completion(apod)
            case .failure(let error):
                debugPrint("failure", error)
                completion(nil)
            }
        }
    }
}

private extension WALELandingAPIWorker {
    
    func createAPODUrl(forDate dateString: String) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = "/planetary/apod"
        components.queryItems = {
          var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: "api_key", value: WALENetworkConstant.apiKey))
            queryItems.append(URLQueryItem(name: "date", value: dateString))

          return queryItems
        }()
        return components.url
    }
}
