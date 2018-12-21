//
//  Staff.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Employee<Processed: MoneyGiver>: Staff, Processable {
    
    override var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify {
                $0 = newValue
                self.notify($0)
            }
        }
    }

    let name: String

    private let queue: DispatchQueue
    private let range = 0.1..<1.0

    init(name: String, queue: DispatchQueue) {
        self.name = name
        self.queue = queue
    }

    convenience init(name: String) {
        self.init(name: name, queue: .background)
    }

    open func doWork(with object: Processed) {

    }

    open func finishProcessing(with object: Processed) {
        
    }
    
    open func finishWork() {
        self.state = .waitForProcessing
    }
    
    func process(_ object: Processed) {
        self.atomicState.modify {
            if $0 == .available {
                $0 = .busy
                self.queue.asyncAfter(deadline: .afterRandomInterval(in: range)) {
                    self.doWork(with: object)
                    self.finishProcessing(with: object)
                    self.finishWork()
                }
            }
        }
    }
}
