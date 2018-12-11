//
//  Staff.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Employee<Processed: MoneyGiver>: MoneyReceiver, MoneyGiver, Stateable {
    
    class StateObserver {
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        typealias Handler = (State) -> ()
        
        weak var sender: Employee?
        var handler: Handler
        
        init(handler: @escaping Handler, sender: Employee?) {
            self.handler = handler
            self.sender = sender
        }
    }
    
    class ObserverCollection {
        
        var observers = Atomic([StateObserver]())
        
        func add(observer: StateObserver) {
            self.observers.modify {
                $0.append(observer)
            }
        }
        
        func notify(state: State) {
            self.observers.modify {
                $0 = $0.filter {
                    $0.isObserving
                }
                $0.forEach {
                    $0.handler(state)
                }
            }
        }
    }
    
    enum State {
        case busy
        case waitForProcessing
        case available
    }
    
    func observer(handler: @escaping StateObserver.Handler) {
        let observer = StateObserver(handler: handler, sender: self)
        self.observers.add(observer: observer)
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            guard self.state != newValue else { return }
            self.atomicState.value = newValue
            self.observers.notify(state: newValue)
        }
    }

    var money: Int {
        return self.atomicMoney.value
    }
    
    var elementsCountInQueue: Int {
        return self.processingQueue.count
    }

    let observers = ObserverCollection()
    
    let name: String
    
    private let atomicState = Atomic(State.available)
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
}
