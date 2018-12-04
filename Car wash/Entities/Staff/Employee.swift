//
//  Staff.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Employee<Processed: MoneyGiver>: MoneyReceiver, MoneyGiver, Stateable {

    enum State {
        case busy
        case waitForProcessing
        case available
    }
    //comment
    var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify {
                if $0 == .busy && newValue == .waitForProcessing {
                    self.completionHandler?()
                }
                $0 = newValue
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    var elementsCountInQueue: Int {
        return self.processingQueue.count
    }
    
    private let atomicState = Atomic(State.available)
    let name: String
    var completionHandler: F.CompletionHandler?
    var eventHandler: F.EventHandler?

    private let atomicMoney = Atomic(0)

    private let queue: DispatchQueue
    private let range = 0.1..<1.0
    private let processingQueue = Queue<Processed>()

    init(name: String, queue: DispatchQueue) {
        self.name = name
        self.queue = queue
        self.completionHandler = nil
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
            self.eventHandler?()
            self.finishWork()
        }
    }
}

//    private func workWithProcessingQueue(with object: Processed) {
//        if let process = self.processingQueue.dequeue() {
//            self.asyncWork(with: process,execute: execute, completion: completion)
//        } else {
//            completion?()
//        }
//    }
