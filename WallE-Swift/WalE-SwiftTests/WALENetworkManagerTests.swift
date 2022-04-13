//
//  WALENetworkManagerTests.swift
//  WalE-SwiftTests
//
//  Created by Abhishek Banerjee on 13/04/22.
//

import Foundation



import XCTest
@testable import WalE_Swift

class WALENetworkManagerTests: XCTestCase {
    
    class MockDataTask: WALEURLSessionDataTaskProtocol {
        var isTaskResumed: Bool = false
        func resume() {
            isTaskResumed = true
        }
    }
    
    class MockSession: WALEURLSessionProtocol {
        let dataTask:MockDataTask
        var resultData: Data? = nil
        var error: Error?
        var statusCode: Int?
        
        private(set) var lastUrl: URL?

        init(withDataTask task: MockDataTask) {
            self.dataTask = task
        }
        
        func task(withRequest request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> WALEURLSessionDataTaskProtocol {
            
            lastUrl = request.url
            
            var urlResponse: URLResponse?
            if let statusCode = statusCode {
                urlResponse = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            }
            completionHandler(resultData, urlResponse, error)
            return dataTask
        }
    }
    
    struct MockModel: Codable {
        var name: String
        
        enum CodingKeys: CodingKey {
            case name
        }
    }

    private var sut:WALENetworkManager!
    private var session: MockSession!
    private var mockUrl: URL!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockSession(withDataTask: MockDataTask())
        sut = WALENetworkManager(with: session)
        mockUrl = URL(string: "https://www.google.com")!
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        session = nil
    }
    
    func test_URL_DataTaskExecution() {
        session.statusCode = 200
        sut.get(from: mockUrl) { (result: Result<MockModel, WALEError>) in
        }
        XCTAssertEqual(session.lastUrl, mockUrl)
        XCTAssert(session.dataTask.isTaskResumed)
    }
    
    func test_APISuccess() {
        
        let model = MockModel(name: "Abhishek")
        let expectedData = try! JSONEncoder().encode(model)
        session.resultData = expectedData
        session.statusCode = 200
        var actualResult: MockModel?
        var actualError: Error?

        sut.get(from: mockUrl) { (result: Result<MockModel, WALEError>) in
            
            switch result {
            case .success(let model):
                actualResult = model
            case .failure(let error):
                actualError = error
            }
        }
        XCTAssertNil(actualError)
        XCTAssertNotNil(actualResult)
    }
    
    func test_APIFailure() {
        
        session.statusCode = 500
        var actualResult: MockModel?
        var actualError: Error?

        sut.get(from: mockUrl) { (result: Result<MockModel, WALEError>) in
            
            switch result {
            case .success(let model):
                actualResult = model
            case .failure(let error):
                actualError = error
            }
        }
        XCTAssertNotNil(actualError)
        XCTAssertNil(actualResult)
    }
}
