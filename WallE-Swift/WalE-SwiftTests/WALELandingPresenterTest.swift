//
//  WALELandingPresenterTest.swift
//  WalE-SwiftTests
//
//  Created by Abhishek Banerjee on 12/04/22.
//

import XCTest
@testable import WalE_Swift

class WALELandingPresenterTest: XCTestCase {
    
    private var sut: WALELandingPresenter!
    private var controller: WALELandingControllerMock!
    
    class WALELandingControllerMock: WALELandingDisplayable {
        
        var isDisplayAPODCalled: Bool = false
//        var isDisplayImageCalled: Bool = false
        var isDisplayLoaderCalled: Bool = false
        var isHideLoaderCalled: Bool = false
        var isDisplayAlertCalled: Bool = false
        var viewModel: WALELandingViewModel? = nil

        func displayAPOD(withViewModel model: WALELandingViewModel) {
            viewModel = model
            isDisplayAPODCalled = true
        }
        
//        func displayImage(withImageData: Data) {
//            isDisplayImageCalled = true
//        }
        
        func displayLoader() {
            isDisplayLoaderCalled = true
        }
        
        func hideLoader() {
            isHideLoaderCalled = true
        }
        
        func displayAlert(withString: String) {
            isDisplayAlertCalled = true
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        controller = WALELandingControllerMock()
        sut = WALELandingPresenter(withViewController: controller)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        controller = nil
    }
    
    func test_PresentAlert() {
        sut.presentAlert(withMessage: "Hey")
        XCTAssertTrue(controller.isDisplayAlertCalled)
    }
    
    func test_presentAPOD() {
        let apod = WALEMockData().apod
        sut.presentAPOD(withAPOD: apod)
        XCTAssertTrue(controller.isDisplayAPODCalled)
        guard let model = controller.viewModel else {
            XCTFail("view model should not be nil")
            return
        }
        //this only to test apod model data is not being modified before creating view model
        XCTAssertEqual(apod, model.apod)
    }
    
//    func test_presentImage() {
//
//        let data = Data()
//        sut.presentImage(withImageData: data)
//        XCTAssertTrue(controller.isDisplayImageCalled)
//    }
    
    func test_presentSpinner() {
        
        sut.presentSpinner()
        XCTAssertTrue(controller.isDisplayLoaderCalled)
    }

    func test_hideSpinner() {
        
        sut.hideSpinner()
        XCTAssertTrue(controller.isHideLoaderCalled)
    }
}

//this equtable is only limited to testing, In main business logic there is no requirement to equate them
extension APOD: Equatable {
   public static func == (lhs: APOD, rhs: APOD) -> Bool {
        return (lhs.title == rhs.title) && (lhs.explanation == rhs.explanation)
    }
}
