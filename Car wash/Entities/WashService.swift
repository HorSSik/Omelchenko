//
//  Service.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class WashService {
    
    private let managerWashers: StaffManager<Car, Washer>
    private let managerAccountant: StaffManager<Washer, Accountant>
    private let managerDirector: StaffManager<Accountant, Director>
    
    private var washerObserver = Atomic([StaffManager<Car, Washer>.Observer]())
    private var accountantObserver = Atomic([StaffManager<Washer, Accountant>.Observer]())
    
    private var cancelladObservers = CompositCancellableProperty()
    
    init(
        washers: [Washer],
        accountant: Accountant,
        director: Director
    ) {
        self.managerWashers = StaffManager(objects: washers)
        self.managerAccountant = StaffManager(object: accountant)
        self.managerDirector = StaffManager(object: director)
        self.subscribe()
    }
    
    func wash(_ car: Car) {
        self.managerWashers.processObject(car)
    }
    
    private func subscribe() {
        let washerCancelladObserver = self.managerWashers.observer { washer in
            self.managerAccountant.processObject(washer)
        }
        
        let accountantCancelladObserver = self.managerAccountant.observer { accountant in
            self.managerDirector.processObject(accountant)
        }
        
        self.cancelladObservers.value = [washerCancelladObserver, accountantCancelladObserver]
    }
}

