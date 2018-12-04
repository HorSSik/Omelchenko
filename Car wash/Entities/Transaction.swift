
import Foundation

class Transaction: CustomStringConvertible {
    
    let money: Money
    
    init(money: Money) {
        self.money = money
    }
    
    var description: String {
        return "\(self.money.value)"
    }
}
