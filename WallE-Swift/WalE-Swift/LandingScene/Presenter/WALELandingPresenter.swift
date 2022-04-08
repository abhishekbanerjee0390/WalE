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
}


final class WALELandingPresenter {
    
    weak private var viewController: WALELandingDisplayable?
    init(withViewController controller: WALELandingDisplayable) {
        self.viewController = controller
    }
}

extension WALELandingPresenter: WALELandingPresentable {
    
    func presentAPOD(withAPOD model: APOD) {
        let viewModel = WALELandingViewModel(apod: model)
        viewController?.displayAPOD(withViewModel: viewModel)
    }
}
