//
//  Processable.swift
//  Car wash
//
//  Created by Student on 20.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Processable {
    
    associatedtype Processed
    
    func process(_ object: Processed)
}
