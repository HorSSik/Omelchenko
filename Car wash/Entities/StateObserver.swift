//
//  StateObserver.swift
//  Car wash
//
//  Created by Student on 11.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StateObserver {
    
    var isObserving: Bool {
        return self.sender != nil
    }
    
    typealias Handler = (Staff.State) -> ()
    
    weak var sender: Staff?
    let handler: Handler
    
    init(handler: @escaping Handler, sender: Staff?) {
        self.handler = handler
        self.sender = sender
    }
}
