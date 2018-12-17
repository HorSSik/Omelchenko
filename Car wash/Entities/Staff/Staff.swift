//
//  Person.swift
//  Car wash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff: ObservableObject<Staff.State>, Stateable, MoneyGiver, MoneyReceiver {
    
    enum State {
        case busy
        case waitForProcessing
        case available
    }
    
    var state = State.available
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    private let atomicMoney = Atomic(0)
    let atomicState = Atomic(State.available)

    func receive(money: Int) {
        self.atomicMoney.modify {
            $0 += money
        }
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
}
