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
            washer.completionHandler = {
                self.accountant.doAsyncWork(with: washer)
            }
        }
        
        self.accountant.completionHandler = {
            self.director.doAsyncWork(with: self.accountant)
        }
        
        self.accountant.eventHandler = {
            self.cars.dequeue().do(self.wash)
        }
        
        self.director.completionHandler = {
            print("Completion Director")
        }
    }
}
