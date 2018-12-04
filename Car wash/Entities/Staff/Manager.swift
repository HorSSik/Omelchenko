//
//  ManagerState.swift
//  Car wash
//
//  Created by Student on 13.11.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Manager<Processed: MoneyGiver & Stateable>: Employee<Processed> {
    
    override func doWork(with object: Processed) {
        self.receiveMoney(moneyGiver: object)
    }
    
    override func finishProcessing(with object: Processed) {
        object.state = .available
        if self.elementsCountInQueue == 0 {
            self.state = .waitForProcessing
        } else {
            super.finishWork()
        }
    }
}
