//
//  ObservableObject.swift
//  Car wash
//
//  Created by Student on 14.12.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class ObservableObject<Value> {
    
    let observers = ObservableObject.Observers()
    
    func observer(handler: @escaping Observer.Handler) -> Observer {
        let observer = Observer(sender: self, handler: handler)
        self.observers.add(observer: observer)
        
        return observer
    }
}
