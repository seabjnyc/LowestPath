//
//  MatrixSampleTests.swift
//  LowestCostPath
//
//  Created by Seab on 04/22/17.
//  Copyright © 2017 NA. All rights reserved.
//

import XCTest
@testable import LowestCostPath

    //9 Sample Tests

class MatrixSampleTests: XCTestCase {
    
    
    //Sample 1: (6X5 matrix normal flow)
    func testForSample1() {
        
        let input = "3 4 1 2 8 6\n6 1 8 2 7 4\n5 9 3 9 9 5\n8 4 1 3 2 6\n3 7 2 8 6 4";
        let expectedPath = [1,2,3,4,4,5]
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertTrue(result.pathCompleted)
                XCTAssertTrue(result.cost == 16)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
    }
    
  //  Sample 2: (6X5 matrix normal flow)
    func testForSample2() {
        let input = "3 4 1 2 8 6\n6 1 8 2 7 4\n5 9 3 9 9 5\n8 4 1 3 2 6\n3 7 2 1 2 3";
        let expectedPath = [1,2,1,5,4,5]

        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertTrue(result.pathCompleted)
                XCTAssertTrue(result.cost == 11)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
    }
    
 //   Sample 3: (5X3 matrix with no path <50)
    func testForSample3() {
        let input = "19 10 19 10 19\n21 23 20 19 12\n20 12 20 11 10";
        let expectedPath = [1,1,1]
    
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertFalse(result.pathCompleted)
                XCTAssertTrue(result.cost == 48)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
    }
    
    //Sample 4: (1X5 matrix)
    
    func testForSample4() {
        let input = "5 8 5 3 5";
        let expectedPath = [1,1,1,1,1]

        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertTrue(result.pathCompleted)
                XCTAssertTrue(result.cost == 26)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
        
    }
    
   // Sample 5: (5X1 matrix)
    func testForSample5() {
        let input = "5\n8\n5\n3\n5"
        let expectedPath = [4]
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertTrue(result.pathCompleted)
                XCTAssertTrue(result.cost == 3)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
        
    }
    
    
    //Sample 6: (Non numeric input, Optional) //condition inside MatrixParse.swift
    func testForSample6() {
        let input = "5 4 H\n8 M 7\n5 7 5"
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertFalse(result.pathCompleted)
            }
        }
        catch let error {
            XCTAssertTrue(error.localizedDescription == "Invalid matrix")
        }
    }

    
    
   // Sample 7: (No input - Optional)  //condition inside MatrixParse.swift
    func testForSample7() {
        let input = ""
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertFalse(result.pathCompleted)
            }
        }
        catch let error {
            XCTAssertTrue(error.localizedDescription == "No input")
        }
    }
    
   // Sample 8: (Starting with >50)
    func testForSample8() {
        let input = "69 10 19 10 19\n51 23 20 19 12\n60 12 20 11 10"
        let expectedPath:[Int] = []
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertFalse(result.pathCompleted)
                XCTAssertTrue(result.cost == 0)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
        
        
    }
    
    //Sample 9: (One value >50)
    func testForSample9() {
        let input = "60 3 3 6\n6 3 7 9\n5 6 8 3"
        let expectedPath:[Int] = [3,2,1,3]
        
        do {
            let handler = try MatrixHandler(with: input)
            if let result = handler.calculateMinimumCost() {
                XCTAssertTrue(result.pathCompleted)
                XCTAssertTrue(result.cost == 14)
                XCTAssertTrue(result.path == expectedPath)
            }
        }
        catch let error {
            XCTAssertNil(error)
        }
        
    }
    

}
