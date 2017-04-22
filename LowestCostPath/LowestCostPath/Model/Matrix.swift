//
//  Matrix.swift
//  LowestCostPath
//
//  Created by Seab on 04/22/17.
//  Copyright © 2017 NA. All rights reserved.
//

import Foundation

// Matrix model
class Matrix {
    
    var numberOfColumns = 0
    var numberOfRows = 0
    var costValues: [[Int]]?
    
    init(listOfCostValues:[[Int]]) {
        costValues = listOfCostValues
        numberOfRows = costValues!.count
        
        if numberOfRows > 0{
            numberOfColumns = (costValues?.first?.count)!
        }
    }
    
}
