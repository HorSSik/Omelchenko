//
//  Observeable.swift
//  Car wash
//
//  Created by Student on 05.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Observable {
    
    func addObserver(_ observer: Observer)
    
    func removeObserver(forIdentifier: Int)
}
