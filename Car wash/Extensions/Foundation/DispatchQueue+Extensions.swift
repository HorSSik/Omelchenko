//
//  DispatchQueue+Extension.swift
//  Car wash
//
//  Created by Student on 25.10.2018.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static var userInteractive = DispatchQueue.global(qos: .userInteractive)
    static var userInitiated = DispatchQueue.global(qos: .userInitiated)
    static var unspecified = DispatchQueue.global(qos: .unspecified)
    static var background = DispatchQueue.global(qos: .background)
    static var `default` = DispatchQueue.global(qos: .default)
    static var utility = DispatchQueue.global(qos: .utility)
    
    class CancellationToken {
        
        let atomicToken = Atomic(true)
        
        var isRunning: Bool {
            return self.atomicToken.value
        }
        
        func cancel() {
            self.atomicToken.value = false
        }
    }
    
    func timer(
        interval: TimeInterval,
        execute: @escaping F.Execute
    )
        -> CancellationToken
    {
        let token = CancellationToken()
        self.nextStep(token: token, interval: interval, execute: execute)
        
        return token
    }
    
    private func nextStep(
        token: CancellationToken,
        interval: TimeInterval,
        execute: @escaping F.Execute
    ) {
        self.asyncAfter(deadline: .after(interval: interval)) {
            if token.isRunning {
                execute()
                self.nextStep(token: token, interval: interval, execute: execute)
            }
        }
    }
}
