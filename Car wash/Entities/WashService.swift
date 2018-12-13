//
//  Service.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class WashService {
    
    private let accountant: Accountant
    private let director: Director
    
    private let cars = Queue<Car>()
    private let washers: Atomic<[Washer]>
    private var observers = [StateObserver]()
    
    deinit {
        print("DEINIT")
        self.observers.forEach {
            $0.cancel()
        }
    }
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director
    ) {
        self.washers = Atomic(washers)
        self.accountant = accountant
        self.director = director
        self.subscribe()
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
    
    private func subscribe() {
        self.washers.value.forEach { washer in
<<<<<<< HEAD
            washer.observer {
                switch $0 {
                case .available:
                    self.cars.dequeue().do(washer.doAsyncWork)
                case .waitForProcessing:
                    self.accountant.doAsyncWork(with: washer)
                case .busy:
                    return
                }
            }
        }
        
        self.accountant.observer {
            switch $0 {
            case .waitForProcessing:
                self.director.doAsyncWork(with: self.accountant)
            default: return
            }
        }
        
        self.director.observer {
=======
            let observerWasher = washer.observer { [weak self, weak washer] in
                switch $0 {
                case .available: self?.cars.dequeue().apply(washer?.doAsyncWork)
                case .waitForProcessing: washer.apply(self?.accountant.doAsyncWork)
                case .busy: return
                }
            }
            self.observers.append(observerWasher)
        }
        
        let observerAccountant = self.accountant.observer { [weak self, weak accountant] in
            switch $0 {
            case .waitForProcessing: accountant.apply(self?.director.doAsyncWork)
            case .available: accountant?.checkProcessingQueue()
            case .busy: print("Accountant - Busy")
            }
        }
        self.observers.append(observerAccountant)
        
        let observerDirector = self.director.observer {
>>>>>>> feature/observer
            switch $0 {
            case .available: print("Director - Available")
            case .waitForProcessing: print("Director - WaitForProcessing")
            case .busy: print("Director - Busy")
            }
        }
        self.observers.append(observerDirector)
    }
}
