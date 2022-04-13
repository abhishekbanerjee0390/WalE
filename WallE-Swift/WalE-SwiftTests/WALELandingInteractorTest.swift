//
//  WALELandingInteractorTest.swift
//  WalE-SwiftTests
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import XCTest
@testable import WalE_Swift


class WALELandingInteractorTest: XCTestCase {
    
    class LandingPresenterMock: WALELandingPresentable {
        
        var isPresenterSpinnerCalled: Bool = false
        var isHideSpinnerCalled: Bool = false
        var isPresentAlertCalled: Bool = false
        var isPresentImageCalled: Bool = false
        var isPresentAPODCalled: Bool = false
        var alertMessage:String = ""

        func presentAPOD(withAPOD model: APOD) {
            isPresentAPODCalled = true
        }
        
        func presentImage(withImageData imageData: Data) {
            isPresentImageCalled = true
        }
        
        func presentSpinner() {
            isPresenterSpinnerCalled = true
        }
        
        func hideSpinner() {
            isHideSpinnerCalled = true
        }
        
        func presentAlert(withMessage message: String) {
            isPresentAlertCalled = true
            alertMessage = message
        }
    }
    
    class APIWorkerMock: WALELandingAPIWorkerProtocol {
        
        var isRequesToGetPictureOfTheDayCalled = false
        var isRequesToDownloadImage = false

        func requestToGetPictureOfTheDay(forDate dateString: String, completion: @escaping (APOD?) -> Void) {
            isRequesToGetPictureOfTheDayCalled = true
            completion(WALEMockData().apod)
        }
        
        func requestToDownloadImage(fromURL url: URL, completion: @escaping (Data?) -> Void) {
            isRequesToDownloadImage = true
            let imageData = UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.1)
            completion(imageData ?? Data())
        }
    }
    
    class StorageManagerMock: WallEStorageManagerProtocol {
        
        var object: APOD? = nil
        var isGetObjectCalled: Bool = false
        var isSetObjectCalled: Bool = false
        var matchDateString: String? = nil
       
        func setObject<Element>(value: Element, forKey key: String) throws where Element : Encodable {
            isSetObjectCalled = true
        }
        
        func getObject<Element>(forKey key: String) throws -> Element? where Element : Decodable {
            isGetObjectCalled = true
            let element = (object as? Element)
            if let dateString = matchDateString {
                return (dateString == key) ? element : nil
            }
            return element
        }
    }
    
    class NetworkMonitorMock: WALENetworkMonitorProtocol {
        var isConnected: Bool  {
            return connected
        }
        
        var connected: Bool = false
        
        func startMonitoringNetwork(_ statusChanged: @escaping WALENetworkStatusChanged) {
            statusChanged(isConnected)
        }
    }
    
    private var sut: WALELandingInteractor!
    private var presenter: LandingPresenterMock!
    private var monitor: NetworkMonitorMock!
    private var api: APIWorkerMock!
    private var storage: StorageManagerMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        presenter = LandingPresenterMock()
        storage = StorageManagerMock()
        api = APIWorkerMock()
        monitor = NetworkMonitorMock()
        sut = WALELandingInteractor(withPresenter: presenter, apiWorker: api, storageManager: storage, networkMonitor: monitor)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        presenter = nil
        storage = nil
        api = nil
        monitor = nil
        sut = nil
    }
    
    func testPresentAPOD_WhenInternetIsConnected_LocalDataNotAvailableForToday() {
        monitor.connected = true
        sut.processViewDidLoad()
        XCTAssertTrue(presenter.isPresenterSpinnerCalled)
        XCTAssertTrue(storage.isGetObjectCalled)
        XCTAssertTrue(api.isRequesToGetPictureOfTheDayCalled)
        XCTAssertTrue(api.isRequesToDownloadImage)
        XCTAssertTrue(storage.isSetObjectCalled)
        XCTAssertTrue(presenter.isPresentAPODCalled)
        XCTAssertTrue(presenter.isHideSpinnerCalled)
    }
    
    func testPresentAPOD_WhenInternetIsConnected_LocalDataAvailableForToday() {
        monitor.connected = true
        storage.object = WALEMockData().apod
        sut.processViewDidLoad()
        //no need of starting the spinner because data is presented from local
        XCTAssertFalse(presenter.isPresenterSpinnerCalled)
        XCTAssertTrue(storage.isGetObjectCalled)
        XCTAssertFalse(api.isRequesToGetPictureOfTheDayCalled)
        XCTAssertFalse(api.isRequesToDownloadImage)

        //when we already have data in local set data in storage should not have called
        XCTAssertFalse(storage.isSetObjectCalled)
        XCTAssertTrue(presenter.isPresentAPODCalled)
        //no need of hiding the spinner
        XCTAssertFalse(presenter.isHideSpinnerCalled)
    }
    
    func testPresentAPOD_WhenInternetIsNotConnected_LocalDataAvailableForToday() {
        monitor.connected = false
        storage.object = WALEMockData().apod
        sut.processViewDidLoad()
        XCTAssertTrue(storage.isGetObjectCalled)
        //when we already have data in local set data in storage should not have called
        XCTAssertFalse(storage.isSetObjectCalled)
        XCTAssertFalse(api.isRequesToGetPictureOfTheDayCalled)
        XCTAssertFalse(api.isRequesToDownloadImage)
        XCTAssertTrue(presenter.isPresentAPODCalled)
        //no need of hiding the spinner
        XCTAssertFalse(presenter.isHideSpinnerCalled)
    }
    
    func testPresentAPOD_WhenInternetIsNotConnected_LocalDataAvailableForYesterday() {
        monitor.connected = false
        storage.object = WALEMockData().apod
        guard let yestDayString = Date().daysAgo(1)?.stringValue() else {
            XCTFail("yesterday day string should not be nil")
            return
        }
        //this will match yeterday date and confirm that data will be return only if we are providing yesterday's date
        storage.matchDateString = yestDayString
        sut.processViewDidLoad()
        XCTAssertTrue(storage.isGetObjectCalled)
        //when we already have data in local set data in storage should not have called
        XCTAssertFalse(storage.isSetObjectCalled)
        XCTAssertFalse(api.isRequesToGetPictureOfTheDayCalled)
        XCTAssertFalse(api.isRequesToDownloadImage)
        XCTAssertTrue(presenter.isPresentAPODCalled)
        XCTAssertTrue(presenter.isPresentAlertCalled)
        XCTAssertEqual(presenter.alertMessage, WALEStringConstant.alertYesterdayData)

        //no need of hiding the spinner
        XCTAssertFalse(presenter.isHideSpinnerCalled)
    }
    
    func testPresentAPOD_WhenInternetIsNotConnected_LocalDataNotAvailable() {
        monitor.connected = false
        sut.processViewDidLoad()
        XCTAssertTrue(storage.isGetObjectCalled)
        XCTAssertFalse(storage.isSetObjectCalled)
        XCTAssertFalse(api.isRequesToGetPictureOfTheDayCalled)
        XCTAssertFalse(api.isRequesToDownloadImage)
        XCTAssertFalse(presenter.isPresentAPODCalled)
        XCTAssertTrue(presenter.isPresentAlertCalled)
        XCTAssertEqual(presenter.alertMessage, WALEStringConstant.alertNoData)
        XCTAssertFalse(presenter.isHideSpinnerCalled)
    }
}


