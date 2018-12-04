//
//  RangeReplacebleCollection+Extension.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    mutating func safeRemoveFirst() -> Element? {
        return self.isEmpty ? nil : self.removeFirst()
    }
}
