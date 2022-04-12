//
//  WALELandingConfigurator.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import Foundation

protocol WALELandingConfiguratorProtocol {
    func setup(withController controller: WALELandingViewController) -> WALELandingInteractable
}

//MARK: - WALELandingConfiguratorProtocol -
final class WALELandingConfigurator: WALELandingConfiguratorProtocol {
    
     func setup(withController controller: WALELandingViewController) -> WALELandingInteractable {
        
        let presenter = WALELandingPresenter(withViewController: controller)
         let interactor = WALELandingInteractor(withPresenter: presenter, apiWorker: WALELandingAPIWorker(), storageManager: WallEStorageManager.shared, networkMonitor: WALENetworkMonitor())
         return interactor
    }
}
