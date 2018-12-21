//
//  StaffManager.swift
//  Car wash
//
//  Created by Student on 20.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StaffManager<Processed: MoneyGiver, ProcessableObject: Employee<Processed>>: ObservableObject<ProcessableObject> {
    
    private let processedQueue = Queue<Processed>()
    private let processableObjects = Atomic([ProcessableObject]())
    private var observers = Atomic([Staff.Observer]())
    
    private var elementsCountInQueue: Int {
        return self.processedQueue.count
    }
    
    init(objects: [ProcessableObject]) {
        self.processableObjects.value = objects
        super.init()
        self.subscribe()
    }
    
    convenience init(object: ProcessableObject) {
        self.init(objects: [object])
    }
    
    public func processObject(_ object: Processed) {
        self.processableObjects.transform {
            let availableObject = $0.first { $0.state == .available }
            
            if self.processedQueue.isEmpty {
                if let availableObject = availableObject {
                    if let queueObject = self.processedQueue.dequeue() {
                        availableObject.process(queueObject)
                    } else {
                        availableObject.process(object)
                    }
                } else {
                    self.processedQueue.enqueue(object)
                }
            } else {
                self.processedQueue.enqueue(object)
            }
        }
    }
    
    private func subscribe() {
        self.observers.value += self.processableObjects.value.map { object in
            let observers = object.observer { [weak self, weak object] state in
                DispatchQueue.background.async {
                    switch state {
                    case .available:
                        self?.processedQueue.dequeue().apply(object?.process)
                    case .waitForProcessing:
                        object.apply(self?.notify)
                    case .busy: return
                    }
                }
            }
            
            return observers
        }
    }
}
