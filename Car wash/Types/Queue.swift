//
//  Queue.swift
//  Car wash
//
//  Created by Student on 29.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Queue<Element> {
    
    var isEmpty: Bool {
        return self.elements.value.isEmpty
    }
    
    var count: Int {
        return self.elements.value.count
    }
    
    private let elements = Atomic([Element]())
    
    func enqueue(_ value: Element) {
        self.elements.modify {
            $0.append(value)
        }
    }
    
    func dequeue() -> Element? {
        return self.elements.modify {
            $0.safeRemoveFirst()
        }
    }
}
