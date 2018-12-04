//
//  Stateable.swift
//  Car wash
//
//  Created by Student on 07.11.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Stateable: class {
    
    associatedtype Processed: MoneyGiver
    
    var state: Employee<Processed>.State { get set }
}
