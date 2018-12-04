//
//  Optional+Extension.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension Optional {
    
    func `do`(_ action: (Wrapped) -> ()) {
        self.map(action)
    }
}
