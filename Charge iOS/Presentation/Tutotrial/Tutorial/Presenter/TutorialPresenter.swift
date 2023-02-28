//
//  TutorialPresenter.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 27.01.2022.
//

import Foundation

protocol TutorialProtocol: class {
    func setData(data: [TutorialModel])
}

protocol TutorialPresenterImpl: class {
    init(view: TutorialProtocol, dataArray: [TutorialModel])
    func loadData()
}

class TutorialPresenter: TutorialPresenterImpl {
    
    weak var view: TutorialProtocol?
    let dataArray: [TutorialModel]
    
    required init(view: TutorialProtocol, dataArray: [TutorialModel]) {
        self.view = view
        self.dataArray = dataArray
    }
    
    func loadData() {
        let data = self.dataArray
        self.view?.setData(data: data)
    }
    
}
