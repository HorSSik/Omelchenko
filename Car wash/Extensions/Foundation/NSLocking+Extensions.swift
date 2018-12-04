//
//  NSLock+Extensions.swift
//  Car wash
//
//  Created by Student on 30.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension NSLocking {
    
    func locked<Result>(action: () -> Result) -> Result {
        self.lock()
        defer { self.unlock() }
        
        return action()
    }
}
