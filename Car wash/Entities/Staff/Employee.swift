//
//  Staff.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Employee<Processed: MoneyGiver>: Staff {
    
    var elementsCountInQueue: Int {
        return self.processingQueue.count
    }

    let name: String

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

    func doWork(with object: Processed) {

    }

    func finishProcessing(with object: Processed) {
        
    }
    
    func finishWork() {
        if let person = self.processingQueue.dequeue() {
            self.asyncWork(with: person)
        } else {
            self.state = .waitForProcessing
        }
    }
    
    func checkProcessingQueue() {
        self.processingQueue.dequeue().do(self.doAsyncWork)
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
