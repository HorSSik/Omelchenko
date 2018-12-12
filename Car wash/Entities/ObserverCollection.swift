//
//  ObserverCollection.swift
//  Car wash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class ObserverCollection {
    
    let observers = Atomic([StateObserver]())
    
    func add(observer: StateObserver) {
        self.observers.modify {
            $0.append(observer)
        }
    }
    
    func notify(state: Staff.State) {
        self.observers.modify {
            $0 = $0.filter {
                $0.isObserving
            }
            $0.forEach {
                $0.handler(state)
            }
        }
    }
}
