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
    
    private let cars = Queue<Car>()
    
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
    
    func subscribe() {
        self.managerWashers.observer(handler: self.managerAccountant.processObject)
        self.managerAccountant.observer(handler: self.managerDirector.processObject)
    }
}
