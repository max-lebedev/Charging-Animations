//
//  MainMenuPresenter.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 01.02.2022.
//

import Foundation

protocol MainMenuProtocol: class {
    func setData(data: [MainMenuModel])
}

protocol MainMenuPresenterImpl: class {
    init(view: MainMenuProtocol, dataArray: [MainMenuModel])
    func loadData()
}

class MainMenuPresenter: MainMenuPresenterImpl {
    
    weak var view: MainMenuProtocol?
    let dataArray: [MainMenuModel]
    
    required init(view: MainMenuProtocol, dataArray: [MainMenuModel]) {
        self.view = view
        self.dataArray = dataArray
    }
    
    func loadData() {
        let data = self.dataArray
        self.view?.setData(data: data)
    }
}
