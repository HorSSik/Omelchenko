
import Foundation

extension NSLock {
    
    func lock (action: () -> () ) {
        self.lock()
        action()
        self.unlock()
    }
}
