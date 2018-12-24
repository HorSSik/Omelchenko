//
//  AbstractCancellableProperty.swift
//  Car wash
//
//  Created by Student on 24.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class AbstractCancellableProperty<Storage> {
    
    public var value: Storage {
        get { return self.atomicCancellable.value }
        set { self.atomicCancellable.value = newValue }
    }
    
    private let atomicCancellable: Atomic<Storage>
    
    init(initial: Storage, dispose: @escaping (Storage) -> ()) {
        self.atomicCancellable = Atomic(initial, lock: .init()) {
            dispose($0.old)
        }
    }
}

class CancellableProperty: AbstractCancellableProperty<Cancellable?> {
    
    init() {
        super.init(initial: nil) { $0?.cancel() }
    }
}

class CompositCancellableProperty: AbstractCancellableProperty<[Cancellable]> {
    
    init() {
        super.init(initial: []) {
            $0.forEach { $0.cancel() } 
        }
    }
}
