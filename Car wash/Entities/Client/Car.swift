//
//  Car.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Car: MoneyGiver {
    
    enum CarState {
        case clean
        case dirty
    }
    
    let name: String
    let state = Atomic<CarState>(.dirty)
    
    private let atomicMoney = Atomic(0)
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    init(money: Int, name: String) {
        self.atomicMoney.value = money
        self.name = name
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
}
