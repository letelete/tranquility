import Foundation
import SwiftUI

struct Balance {
    private enum BalanceState {
        case youOwe, youAreOwed, allSet
    }
    
    private var state: BalanceState = BalanceState.allSet
    
    var status: String = ""
    var color: Color = Color.blue
    var asFormatted: String = ""
    
    init(balance: Int) {
        self.state = self.getBalanceState(balance: balance)
        self.status = self.getBalanceStatus()
        self.color = self.getBalanceColor()
        self.asFormatted = self.getFormattedBalance(balance: balance)
    }
    
    private func getBalanceState(balance: Int) -> BalanceState {
        switch balance {
        case ..<0:
            return BalanceState.youOwe
        case 1...:
            return BalanceState.youAreOwed
        default:
            return BalanceState.allSet
        }
    }
    
    private func getBalanceStatus() -> String {
        switch self.state {
        case .youOwe:
            return "You owe"
        case .youAreOwed:
            return "You're owed"
        default:
            return "You're all set!"
        }
    }
    
    private func getBalanceColor() -> Color {
        switch self.state {
        case .youOwe:
            return Color.red
        default:
            return Color.blue
        }
    }
    
    private func getFormattedBalance(balance: Int) -> String {
        let balanceDecimal = Double(balance) / 100
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        if balance != 0 {
            formatter.positivePrefix = formatter.plusSign
        }
        
        let balanceString = formatter.string(from: NSNumber(value: balanceDecimal))
        
        return balanceString ?? "0"
    }
}
