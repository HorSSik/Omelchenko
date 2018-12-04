//
//  Director.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Director: Manager<Accountant> {
    
    override func finishWork() {
        self.state = .available
        var result = "👑Director \(self.name) receive money"
        result += ", and have - \(self.money)💰"
        print(result)
    }
}
