//
//  Service.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class WashService: Observer {
    
    private let accountant: Accountant
    private let director: Director
    
    private let cars = Queue<Car>()
    private let washers: Atomic<[Washer]>
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director
    ) {
        self.washers = Atomic(washers)
        self.accountant = accountant
        self.director = director        
        self.setCompletion()
    }
    
    func wash(_ car: Car) {
        self.washers.transform {
            let availableWasher = $0.first { $0.state == .available }
            if let washer = availableWasher {
                washer.doAsyncWork(with: car)
            } else {
                self.cars.enqueue(car)
            }
        }
    }
    
    private func setCompletion() {
        self.washers.value.forEach { washer in
            washer.observer = self
//            washer.stateToWaitForProcessing = {
//                self.accountant.doAsyncWork(with: washer)
//            }
//            washer.stateToAvailable = {
//                self.cars.dequeue().do(washer.doAsyncWork)
//            }
        }
        
        self.accountant.observer = self
        self.director.observer = self

//        self.accountant.stateToWaitForProcessing = {
//            self.director.doAsyncWork(with: self.accountant)
//        }
    }
    
    func handlingWaitForProcessing<T>(sender: T) {
        if sender is Accountant {
            self.director.doAsyncWork(with: self.accountant)
        } else if let washer = sender as? Washer {
            self.accountant.doAsyncWork(with: washer)
        }
    }
    
    func handlingAvailable<T>(sender: T) {
        if let washer = sender as? Washer {
            self.cars.dequeue().do(washer.doAsyncWork)
        }
    }
    
    func didChange() {
        print("DID CHANGE")
    }
}

protocol Observeable {
    
    func addObserver(observer: Observer)
    
    func removeObserver()
    
    func notify()
}

protocol Observer {
    
    func didChange()
    
    func handlingWaitForProcessing<T>(sender: T)
    
    func handlingAvailable<T>(sender: T)
    
}
