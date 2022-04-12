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
    
    private let todaysDate: Date
    private let presenter: WALELandingPresentable
    private let networkMonitor: WALENetworkMonitorProtocol
    
    private let apiWorker: WALELandingAPIWorkerProtocol
    private let storageManager: WallEStorageManagerProtocol
    
    init(withPresenter presenter: WALELandingPresentable, apiWorker: WALELandingAPIWorkerProtocol, storageManager: WallEStorageManagerProtocol, networkMonitor: WALENetworkMonitorProtocol) {
        self.presenter = presenter
        self.apiWorker = apiWorker
        self.storageManager = storageManager
        self.networkMonitor = networkMonitor
        self.todaysDate = Date()
    }
}

//MARK: - WALELandingInteractable -
extension WALELandingInteractor: WALELandingInteractable {
    func processViewDidLoad() {
        loadAPOD()
    }
}

//MARk: - Private -
private extension WALELandingInteractor {
    
    func validateDate(_ date: Date, _ closure: (String) -> ()) {
        guard let dateString = date.stringValue() else {
            debugPrint("today's date should not be nil")
            return
        }
        closure(dateString)
    }
    
    func loadAPOD() {
        self.networkMonitor.startMonitoringNetwork { [weak self] isConnected in
            guard let safeSelf = self else { return }
            if isConnected {
                safeSelf.handleFlowWithInternet(forDate: safeSelf.todaysDate)
            } else {
                safeSelf.handleFlowWithoutInternet(forDate: safeSelf.todaysDate)
            }
        }
    }
    
    func checkAPODExistsInCache(forDate date: Date) -> APOD? {
        
        var apod: APOD? = nil
        validateDate(date) { dateString in
            apod = try? storageManager.getObject(forKey: dateString)
        }
        debugPrint("getting value from cache", (apod ?? ""))
        return apod
    }
    
    func setAPODInCache(_ apod: APOD) {
        debugPrint("settings value in cache", apod)
        validateDate(todaysDate) { date in
            try? storageManager.setObject(value: apod, forKey: date)
        }
    }
    
    func downloadImageFromServer(withAPOD apod: APOD) {
        
        guard let url = URL(string: apod.urlString) else {
            debugPrint("unable to create url from url string", apod.urlString)
            return
        }
        apiWorker.requestToDownloadImage(fromURL: url) { [weak self] data in
            if let safeSelf = self, let imageData = data {
                
                safeSelf.validateDate(safeSelf.todaysDate) { date in
                    var mutableAPOD = apod
                    mutableAPOD.imageData = imageData
                    safeSelf.setAPODInCache(mutableAPOD)
                    safeSelf.presenter.presentAPOD(withAPOD: mutableAPOD)
                    safeSelf.presenter.hideSpinner()
                }
            }
        }
    }
    
    func handleFlowWithInternet(forDate date: Date) {
        validateDate(date) { dateString in
            // Showing from local if we have data for current day, since its picture of the day it wont be changing for the whole day.
            if let todaysAPOd = checkAPODExistsInCache(forDate: date) {
                debugPrint("showing values from local")
                presenter.presentAPOD(withAPOD: todaysAPOd)
            } else {
                presenter.presentSpinner()
                apiWorker.requestToGetPictureOfTheDay(forDate: dateString) { [weak self] (apod: APOD?) in
                    if let safeSelf = self, let apod = apod {
                        debugPrint("showing values from sever")
                        safeSelf.downloadImageFromServer(withAPOD: apod)
                    }
                }
            }
        }
    }

    func handleFlowWithoutInternet(forDate date: Date) {
        //if today APOD exists
        if let todaysAPOd = checkAPODExistsInCache(forDate: date) {
            presenter.presentAPOD(withAPOD: todaysAPOd)
        } else  {
            //if yesterday's date exists
            if let yesterdaysDate = date.daysAgo(1), let yesterdaysAPOD = checkAPODExistsInCache(forDate: yesterdaysDate) {
                presenter.presentAPOD(withAPOD: yesterdaysAPOD)
                presenter.presentAlert(withMessage: WALEStringConstant.alertYesterdayData)
            } else {
                //this requirement was not in the  acceptance criteria adding it on my own
                //when user has no data of neither today or yesterday, showing just an internet alert
                presenter.presentAlert(withMessage: WALEStringConstant.alertNoData)
            }
        }
    }
}

