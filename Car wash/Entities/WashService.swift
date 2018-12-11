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
            switch $0 {
            case .available: print("Director - Available")
            case .waitForProcessing: print("Director - WaitForProcessing")
            case .busy: print("Director - Busy")
            }
        }
    }
}
