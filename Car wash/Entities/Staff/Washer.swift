//
//  Washer.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Washer: Employee<Car> {
    
    override func doWork(with object: Car) {
        object.state.value = .clean
    }
    
    override func finishProcessing(with object: Car) {
        self.receiveMoney(moneyGiver: object)
    }
    
    override func finishWork() {
        self.state = .waitForProcessing
        var result = "💧\(self.name) washed the car🏎️"
        result += ", and have - \(self.money)💰"
        print(result)
    }
}
