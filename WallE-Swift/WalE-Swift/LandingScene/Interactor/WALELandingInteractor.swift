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
    private let networkMonitor: WALENetworkMonitorProtocol
    
    private let apiWorker: WALELandingAPIWorkerProtocol
    private let storageManager: WallEStorageManager
    
    init(withPresenter presenter: WALELandingPresentable) {
        self.presenter = presenter
        self.apiWorker = WALELandingAPIWorker()
        self.storageManager = WallEStorageManager.shared
        self.networkMonitor = WALENetworkMonitor()
    }
}

//MARK: - WALELandingInteractable -
extension WALELandingInteractor: WALELandingInteractable {
    func processViewDidLoad() {
        loadAPOD()
    }
}

//MARk: - Privtae -
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
            let todaysDate = Date()
            if isConnected {
                safeSelf.handleFlowWithInternet(forDate: todaysDate)
            } else {
                safeSelf.handleFlowWithoutInternet(forDate: todaysDate)
            }
        }
    }
    
    func checkAPODExistsInCache(forDate date: Date) -> APOD? {
        
        var apod: APOD? = nil
        validateDate(date) { dateString in
            apod = try? storageManager.getObject(forKey: dateString)
        }
        if let apod = apod, apod.imageData == nil {
            downloadImageFromServer(withAPOD: apod)
        }
        debugPrint("getting value from cache", apod)
        return apod
    }
    
    func setAPODInCache(_ apod: APOD) {
        print("settings value in cache", apod)
        validateDate(Date()) { date in
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
                
                safeSelf.validateDate(Date()) { date in
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
        validateDate(date) { date in
            presenter.presentSpinner()
            apiWorker.requestToGetPictureOfTheDay(forDate: date) { [weak self] (apod: APOD?) in
                if let safeSelf = self, let apod = apod {
                    debugPrint("showing values from sever")
                    safeSelf.downloadImageFromServer(withAPOD:  apod)
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
                presenter.presentAlert(withMessage: "We are not connected to the internet, showing you the last image we have.")
            } else {
                //this requirement was not in the  acceptance criteria adding it on my own
                //when user has no data of neither today or yesterday, showing just an internet alert
                presenter.presentAlert(withMessage: "We are not connected to the internet, please try again when internet is back")
            }
        }
    }
}

