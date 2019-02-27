//
//  VendingMachineSpec.swift
//  VendingMachineTests
//
//  Created by Ari on 27/02/2019.
//  Copyright © 2019 ssungnni. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import VendingMachine

// 음료를 뽑을 수 있다.
// 콜라, 사이다, 주스 중 원하는 음료를 뽑을 수 있다.

// 재고만큼 음료를 구매할 수 있다.
// 동전을 넣을 수 있다.
// 지폐를 넣을 수 있다.
// 거스름 돈을 환전 받을 수 있다.


class VendingMachineSpec: QuickSpec {
    var oVendingMachine: VendingMachine = VendingMachine()
    
    override func spec() {
        describe("자판기에서 음료 뽑기") {
            beforeEach {
                self.oVendingMachine.supply([
                    "Sprite" : 1,
                    "Juice" : 1,
                    "Coke" : 1,
                    ])
            }
            it("콜라, 사이다, 주스 중 원하는 음료를 뽑을 수 있다.", closure: {
                let sBeverage1 = self.oVendingMachine.buy("Sprite")
                let sBeverage2 = self.oVendingMachine.buy("Juice")
                let sBeverage3 = self.oVendingMachine.buy("Coke")
                
                expect(sBeverage1).to(equal("Sprite"))
                expect(sBeverage2).to(equal("Juice"))
                expect(sBeverage3).to(equal("Coke"))
                
            })
            
            it("콜라, 사이다, 주스만 뽑을 수 있다.", closure: {
                let sBeverage1 = self.oVendingMachine.buy("Coffee")
                let sBeverage2 = self.oVendingMachine.buy("Milk")
                
                expect(sBeverage1).to(beNil())
                expect(sBeverage2).to(beNil())
            })
        }
        
        it("재고만큼 음료를 구매할 수 있다.") {
            let oVendingMachine = VendingMachine()
            oVendingMachine.supply(["Coke" : 1])
            let sBeverage1 = oVendingMachine.buy("Coke")
            let sBeverage2 = oVendingMachine.buy("Coke")
            
            expect(sBeverage1).to(equal("Coke"))
            expect(sBeverage2).to(beNil())
        }
    }
}
