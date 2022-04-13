//
//  WALESwiftLandingControllerTest.swift
//  WalE-SwiftTests
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import XCTest
@testable import WalE_Swift

class WALESwiftLandingControllerTest: XCTestCase {
    
    var configurator: WALEConfiguratorMock!
    
    class WALEConfiguratorMock: WALELandingConfiguratorProtocol {
        
        var interactor: WALEInteractorMock!

        func setup(withController controller: WALELandingViewController) -> WALELandingInteractable {
            
            interactor = WALEInteractorMock()
            return interactor
        }
    }
    
    class WALEInteractorMock: WALELandingInteractable {
       
        var isProcessViewDidLoadCalled: Bool = false
        
        func processViewDidLoad() {
            isProcessViewDidLoadCalled = true
        }
    }

    private var sut: WALELandingViewController!
    private var window: UIWindow!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        setupController()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        window = nil
        sut = nil
        configurator = nil
    }
    
    
    func test_processViewDidLoad() {
        window.addSubview(sut.view)
        sut.viewDidAppear(true)
        XCTAssertTrue(configurator.interactor.isProcessViewDidLoadCalled)
    }
    
    func test_TableViewSectionAndRow_WhenImageDataInNotPresent() {
        window.addSubview(sut.view)
        sut.viewDidAppear(true)
        let viewModel = WALELandingViewModel(apod: WALEMockData().apod)
        sut.displayAPOD(withViewModel: viewModel)
        let totalSection = 1
        let numberOfSections = sut.numberOfSections(in: sut.tableView)
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: totalSection)
        XCTAssertEqual(numberOfSections, totalSection)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_TableViewSectionAndRow_WhenImageDataPresent() {
        window.addSubview(sut.view)
        sut.viewDidAppear(true)
        let mockData = WALEMockData()
        var mutableApod = mockData.apod
        mutableApod.imageData = mockData.imageData
        let viewModel = WALELandingViewModel(apod: mutableApod)
        sut.displayAPOD(withViewModel: viewModel)
        let totalSection = 1
        let numberOfSections = sut.numberOfSections(in: sut.tableView)
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: totalSection)
        XCTAssertEqual(numberOfSections, totalSection)
        XCTAssertEqual(numberOfRows, 2)
    }
}

//Private
extension WALESwiftLandingControllerTest {
    
    func setupController() {
        configurator = WALEConfiguratorMock()
        sut = WALELandingViewController(withConfigurator: configurator)
    }
}
