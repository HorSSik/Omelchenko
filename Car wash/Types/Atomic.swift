//
//  Atomic.swift
//  Car wash
//
//  Created by Student on 31.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

public class Atomic<Value> {
    
    public typealias ValueType = Value
    public typealias PropertyObserver = ((old: Value, new: Value)) -> ()
    
    public var value: ValueType {
        get { return self.transform { $0 } }
        set { self.modify { $0 = newValue } }
    }
    
    private var mutableValue: ValueType
    
    private let lock: NSLocking
    public let didSet: (PropertyObserver)?
    
    public init(
        _ value: ValueType,
        lock: NSRecursiveLock = NSRecursiveLock(),
        didSet: PropertyObserver? = nil
    ) {
        self.mutableValue = value
        self.lock = lock
        self.didSet = didSet
    }
    
    @discardableResult
    public func modify<Result>(_ action: (inout ValueType) -> Result) -> Result {
        return self.lock.locked {
            let oldValue = self.mutableValue
            
            defer {
                self.didSet?((oldValue, self.mutableValue))
            }
            
            return action(&self.mutableValue)
        }
    }
    
    public func transform<Result>(_ action: (ValueType) -> Result) -> Result {
        return self.lock.locked {
            action(self.mutableValue)
        }
    }
}
