//
//  Accountant.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Accountant: Manager<Washer> {
    
    override func finishWork() {
        var result = "💻Accountant \(self.name) receive money"
        result += ", and have - \(self.money)💰"
        print(result)
    }
}
