//
//  Service.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class WashService: Observer {
    
    var identifier: Int
    
    private let accountant: Accountant
    private let director: Director
    
    private let cars = Queue<Car>()
    private let washers: Atomic<[Washer]>
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director,
        identifier: Int
    ) {
        self.washers = Atomic(washers)
        self.accountant = accountant
        self.director = director
        self.identifier = identifier
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
            washer.addObserver(self)
        }
        self.accountant.addObserver(self)
        self.director.addObserver(self)
    }
    
    func handleWaitForProcessing<Observable>(sender: Observable) {
        if sender is Accountant {
            self.director.doAsyncWork(with: self.accountant)
        } else if let washer = sender as? Washer {
            self.accountant.doAsyncWork(with: washer)
        }
    }
    
    func handleAvailable<Observable>(sender: Observable) {
        if let washer = sender as? Washer {
            self.cars.dequeue().do(washer.doAsyncWork)
        }
    }
}
