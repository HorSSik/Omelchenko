//
//  StaffManager.swift
//  Car wash
//
//  Created by Student on 20.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StaffManager<Processed: MoneyGiver, ProcessableObject: Employee<Processed>>: ObservableObject<ProcessableObject> {
    
    let processed = Queue<Processed>()
    let processableObjects = Atomic([ProcessableObject]())
    private var observers = Atomic([Staff.Observer]())
    
//    private var elementsCountInQueue: Int {
//        return self.processingQueue.count
//    }
    
    init(objects: [ProcessableObject]) {
        self.processableObjects.value = objects
        super.init()
        self.subscribe()
    }
    
    convenience init(object: ProcessableObject) {
        self.init(objects: [object])
    }
    
    func processObject(_ object: Processed) {
        self.processableObjects.transform {
            let availableObject = $0.first { $0.state == .available }
            if let availableObject = availableObject {
                availableObject.processObject(object)
            } else {
                self.processed.enqueue(object)
            }
        }
    }
    
    private func subscribe() {
        self.observers.value += self.processableObjects.value.map { object in
            let observers = object.observer { [weak self, weak object] state in
                DispatchQueue.background.async {
                    switch state {
                    case .available:
                        self?.processed.dequeue().apply(object?.processObject)
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
