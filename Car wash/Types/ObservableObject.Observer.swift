//
//  ObservableObject+Extensions.swift
//  Car wash
//
//  Created by Student on 14.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observer: Hashable, Cancellable {
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        var isCancelled: Bool {
            return !self.isObserving
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
        
        public static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs === rhs
        }
        
        public func cancel() {
            self.sender = nil
        }
    }
}
