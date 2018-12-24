//
//  main.swift
//  Car wash
//
//  Created by Student on 19.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

let accountant = Accountant(name: "Vlad", queue: .background)
let director = Director(name: "Dima", queue: .background)

let washers = ["Fedor", "Ivan", "Petro", "Jeck"].map(Washer.init)

let washService = WashService(
    washers: washers,
    accountant: accountant,
    director: director
)

var factory = CarFactory(for: washService, interval: 5.0, queue: .background)

factory.start()
//sleep(17)
//factory.stop()

RunLoop.current.run()
