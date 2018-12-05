//
//  Observer.swift
//  Car wash
//
//  Created by Student on 05.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Observer: class {
    
    var identifier: Int { get set }
    
    func handlingWaitForProcessing<T>(sender: T)
    
    func handlingAvailable<T>(sender: T)
}
