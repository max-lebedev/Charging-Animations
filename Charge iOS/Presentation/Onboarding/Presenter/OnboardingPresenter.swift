//
//  OnboardingPresenter.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 10.01.2022.
//

import Foundation
import SwiftyUserDefaults

protocol OnboardingProtocol: class {
    func setData(data: [OnboardingModel])
}

protocol OnboardingPresenterImpl: class {
    init(view: OnboardingProtocol, dataArray: [OnboardingModel])
    func loadData()
    func onboardingSeen()
}

class OnboardingPresenter: OnboardingPresenterImpl {
    
    weak var view: OnboardingProtocol?
    let dataArray: [OnboardingModel]
    
    required init(view: OnboardingProtocol, dataArray: [OnboardingModel]) {
        self.view = view
        self.dataArray = dataArray
    }
    
    func loadData() {
        let data = self.dataArray
        self.view?.setData(data: data)
    }
    
    func onboardingSeen() {
        Defaults.onboardingSeen = true
    }

}
