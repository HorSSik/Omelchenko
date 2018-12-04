
import Foundation

class TimeSpan {
    
    let start = 0.0
    let end = 1.0
    
    func randomDuration() -> Double {
        return .random(in: start...end)
    }
}
