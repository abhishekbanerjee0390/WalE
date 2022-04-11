//
//  WALELandingPresenter.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import Foundation
import UIKit


protocol WALELandingPresentable {
    func presentAPOD(withAPOD model: APOD)
    func presentImage(withImageData imageData: Data)
    func presentSpinner()
    func hideSpinner()
    func presentAlert(withMessage message: String)
}

final class WALELandingPresenter {
    
    weak private var viewController: WALELandingDisplayable?
    init(withViewController controller: WALELandingDisplayable) {
        self.viewController = controller
    }
}

//MARk: - WALELandingPresentable -
extension WALELandingPresenter: WALELandingPresentable {
    func presentAlert(withMessage message: String) {
        viewController?.displayAlert(withString: message)
    }
    
    func presentAPOD(withAPOD model: APOD) {
        let viewModel = WALELandingViewModel(apod: model)
        viewController?.displayAPOD(withViewModel: viewModel)
    }
    
    func presentImage(withImageData imageData: Data) {
        viewController?.displayImage(withImageData: imageData)
    }
    
    func presentSpinner() {
        viewController?.displayLoader()
    }
    
    func hideSpinner() {
        viewController?.hideLoader()
    }
}
