//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Ari on 27/02/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

import Foundation

class VendingMachine {
    
    private var stocks: [String: Int] = [:]
    
    private func hasStocks(_ beverage: String) -> Bool {
        guard let count = stocks[beverage] else { return false }
        return count >= 1 ? true : false
    }
    
    func buy(_ beverage: String) -> String? {
        guard self.hasStocks(beverage),
            let count = stocks[beverage] else { return nil }
        stocks.updateValue(count - 1, forKey: beverage)
        return beverage
    }
    
    func supply(_ stocks: [String: Int]) {
        self.stocks = stocks
    }
}
