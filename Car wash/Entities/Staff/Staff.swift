//
//  Person.swift
//  Car wash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff: Stateable, MoneyGiver, MoneyReceiver {
    
    enum State {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            guard self.state != newValue else { return }
            self.atomicState.value = newValue
            self.observers.notify(state: newValue)
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    private let atomicMoney = Atomic(0)
    let atomicState = Atomic(State.available)
    
    let observers = ObserverCollection()

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
    
    func observer(handler: @escaping StateObserver.Handler) {
        let observer = StateObserver(handler: handler, sender: self)
        self.observers.add(observer: observer)
    }
}
