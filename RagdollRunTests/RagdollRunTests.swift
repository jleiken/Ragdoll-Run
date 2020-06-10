//
//  RegularMariaTests.swift
//  RegularMariaTests
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import XCTest
@testable import Ragdoll_Run

class RagdollRunTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConsistentStyleArrays() throws {
        // verify that the number of styles all match
        XCTAssert(Ragdoll_Run.NUM_STYLES == Ragdoll_Run.STYLES.count)
        XCTAssert(Ragdoll_Run.NUM_STYLES == Ragdoll_Run.STYLES_ORDERING.count)
        XCTAssert(Ragdoll_Run.NUM_STYLES == Ragdoll_Run.STYLES_PRICES.count)
        
        // verify that the style unlocks include only styles in STYLES
        XCTAssert(Ragdoll_Run.NUM_STYLES >= Ragdoll_Run.unlockedStyles.count)
        XCTAssert(Set<String>(Ragdoll_Run.unlockedStyles).count == Ragdoll_Run.unlockedStyles.count)
        for style in Ragdoll_Run.unlockedStyles {
            XCTAssert(Ragdoll_Run.STYLES.keys.contains(style))
        }
    }
    
    func testConsistentCoinArrays() throws {
        XCTAssert(Ragdoll_Run.COIN_PRICES.count == Ragdoll_Run.COIN_OPTIONS.count)
        for coins in Ragdoll_Run.COIN_OPTIONS {
            XCTAssert(Ragdoll_Run.COIN_PRICES.keys.contains(coins))
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
