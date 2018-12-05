//
//  carFactory.swift
//  Car wash
//
//  Created by Student on 07.11.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarFactory {
    
    var isRunning: Bool? {
        return self.token?.isRunning
    }

    private let carCount = 10
    
    private let service: WashService
    private let interval: TimeInterval
    private let queue: DispatchQueue
    private var token: DispatchQueue.CancellationToken? {
        willSet { self.token?.cancel() }
    }
    
    deinit {
        print("deinit - CarFactory")
        self.stop()
    }
    
    init(for washService: WashService, interval: TimeInterval, queue: DispatchQueue) {
        self.service = washService
        self.interval = interval
        self.queue = queue
    }
    
    func start() {
        self.token = self.queue.timer(interval: self.interval) { [weak self] in
            self?.carCount.times {
                self?.queue.async {
                    self?.service.wash(Car(money: 10, name: "Camaro"))
                }
            }
        }
    }

    func stop() {
        self.token = nil
    }
}
