//
//  ObservableObject.Observers.swift
//  Car wash
//
//  Created by Student on 19.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observers {
        
        private let observers = Atomic([Observer]())
        
        public func add(observer: Observer) {
            self.observers.modify {
                $0.append(observer)
            }
        }
        
        func notify(state: Value) { // Need private func notify. Fix.
            self.observers.modify {
                $0 = $0.filter {
                    $0.isObserving
                }
                $0.forEach {
                    $0.handler(state)
                }
            }
        }
        
        public static func += (lhs: Observers, rhs: [Observer]) { // lhs: Observers and rhs: Observers
            lhs.observers.modify {
                $0 += rhs
            }
        }
        
//        static func += (lhs: Observers, rhs: Observers) {
//            lhs.observers.modify {
//                $0 += rhs.observers.value
//            }
//        }
    }
}
