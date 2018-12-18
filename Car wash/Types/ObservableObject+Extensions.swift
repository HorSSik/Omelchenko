//
//  ObservableObject+Extensions.swift
//  Car wash
//
//  Created by Student on 14.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observer: Hashable {
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        typealias Handler = (Value) -> ()
        
        private weak var sender: ObservableObject?
        let handler: Handler
        
        init(sender: ObservableObject?, handler: @escaping Handler) {
            self.handler = handler
            self.sender = sender
        }
        
        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
        
        static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs === rhs
        }
        
        func cancel() {
            self.sender = nil
        }
    }
}

extension ObservableObject {
    
    class Observers {
        
        let observers = Atomic([Observer]())
        
        func add(observer: Observer) {
            self.observers.modify {
                $0.append(observer)
            }
        }
        
        func notify(state: Value) {
            self.observers.modify {
                $0 = $0.filter {
                    $0.isObserving
                }
                $0.forEach {
                    $0.handler(state)
                }
            }
        }
        
        static func += (lhs: Observers, rhs: [Observer]) {
            lhs.observers.modify { $0 += rhs }
        }
    }
}
