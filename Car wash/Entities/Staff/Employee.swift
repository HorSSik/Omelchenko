//
//  Staff.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Employee<Processed: MoneyGiver>: MoneyReceiver, MoneyGiver, Stateable, Observeable {
    
    enum State {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            for (identifier, observer) in observers {
                if let observer = observer.value {
                    self.atomicState.value = newValue
                    switch newValue {
                    case .waitForProcessing:
                        observer.handlingWaitForProcessing(sender: self)
                    case .available:
                        observer.handlingAvailable(sender: self)
                        self.processingQueue.dequeue().do(self.doAsyncWork)
                    case .busy:
                        print("BUSY")
                    }
                } else {
                    self.removeObserver(identifier: identifier)
                }
            }
        }
    }

    var money: Int {
        return self.atomicMoney.value
    }
    
    var elementsCountInQueue: Int {
        return self.processingQueue.count
    }
    
    var observers =  [Int : WeakObserver]()
    
    private let atomicState = Atomic(State.available)
    let name: String

    private let atomicMoney = Atomic(0)

    private let queue: DispatchQueue
    private let range = 0.1..<1.0
    private let processingQueue = Queue<Processed>()

    init(name: String, queue: DispatchQueue) {
        self.name = name
        self.queue = queue
    }

    convenience init(name: String) {
        self.init(name: name, queue: .background)
    }

    func receive(money: Int) {
        self.atomicMoney.modify {
            $0 += money
        }
    }

    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }

            return money
        }
    }

    func doWork(with object: Processed) {

    }

    func finishProcessing(with object: Processed) {
        
    }

    func finishWork() {
        if let person = self.processingQueue.dequeue() {
            self.asyncWork(with: person)
        }
    }
    
    func doAsyncWork(with object: Processed) {
        self.atomicState.modify {
            if $0 == .available {
                $0 = .busy
                self.asyncWork(with: object)
            } else {
                self.processingQueue.enqueue(object)
            }
        }
    }
    
    private func asyncWork(with object: Processed) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: range)) {
            self.doWork(with: object)
            self.finishProcessing(with: object)
            self.finishWork()
        }
    }
    
    func addObserver(observer: Observer) {
        let weakObserver = WeakObserver(value: observer)
        self.observers.updateValue(weakObserver, forKey: observer.identifier)
    }
    
    func removeObserver(identifier: Int) {
        self.observers.removeValue(forKey: identifier)
    }
}
