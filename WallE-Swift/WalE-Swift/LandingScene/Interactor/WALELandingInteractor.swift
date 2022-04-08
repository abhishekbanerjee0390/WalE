//
//  WALELandingInteractor.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation

protocol WALELandingInteractable {
    func processViewDidLoad()
}

final class WALELandingInteractor {
    private let presenter: WALELandingPresentable
    
    private let apiWorker: WALELandingAPIWorkerProtocol
    
    init(withPresenter presenter: WALELandingPresentable) {
        self.presenter = presenter
        self.apiWorker = WALELandingAPIWorker()
    }
}

extension WALELandingInteractor: WALELandingInteractable {
    func processViewDidLoad() {
        guard let currentDate = Date().stringValue() else {
            debugPrint("currentDate should not be nil")
            return
        }
        apiWorker.requestToGetPictureOfTheDay(forDate: currentDate) { [weak self] (apod: APOD?) in
            if let apod = apod {
                self?.presenter.presentAPOD(withAPOD: apod)
            }
        }
    }
}

