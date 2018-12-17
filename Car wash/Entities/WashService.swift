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
    private var observers = Staff.Observers()
    
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
        self.observers += self.washers.value.map { washer in
            let observers = washer.observer { [weak self, weak washer] in
                switch $0 {
                case .available:
                    self?.asyncSubscribe {
                        self?.cars.dequeue().apply(washer?.doAsyncWork)
                    }
                case .waitForProcessing:
                    self?.asyncSubscribe {
                        washer.apply(self?.accountant.doAsyncWork)
                    }
                case .busy: return
                }
            }
            
            return observers
        }
        
        let observerAccountant = self.accountant.observer { [weak self, weak accountant] in
            switch $0 {
            case .waitForProcessing:
                self?.asyncSubscribe {
                    accountant.apply(self?.director.doAsyncWork)
                }
            case .available: return
            case .busy: return
            }
        }
        
        self.observers.add(observer: observerAccountant)
        
        let observerDirector = self.director.observer {
            switch $0 {
            case .available: return
            case .waitForProcessing: return
            case .busy: return
            }
        }
        
        self.observers.add(observer: observerDirector)
    }
    
    private func asyncSubscribe(completion: @escaping F.Completion) {
        DispatchQueue.background.async {
            completion()
        }
    }
}
