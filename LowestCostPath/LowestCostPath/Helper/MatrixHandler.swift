//
//  MatrixHandler.swift
//  LowestCostPath
//
//  Created by Seab on 04/22/17.
//  Copyright © 2017 NA. All rights reserved.
//

import Foundation

enum Result {
    case success(Any?)
    case failure(Error)
}

//CustomError
enum CustomError: LocalizedError {
    case valid
    case incorrectFormat
    case noData
    case unknown
    
    //Localized description
    var errorDescription: String? {
        switch self {
        case .valid:
            return "Valid matrix"
        case .incorrectFormat:
            return "Invalid matrix"
        case .noData:
            return "No input"
        case .unknown:
            return "Unkown error"
        }
    }
}

// This class takes input string and processes the matrix for least cost. 
class MatrixHandler {
    
    private var costMatrix: Matrix!
    private var numOfColumns = 0
    private var numOfRows = 0
    private var columnsProcessed = 0;
    
    init(with inputValues:String) throws {
        
        let result = parse(inputValues)
        
        switch result {
        case .success(let costValues):
            costMatrix = Matrix(listOfCostValues: costValues as! [[Int]])
            numOfColumns = costMatrix.numberOfColumns
            numOfRows = costMatrix.numberOfRows
            break
            
        case .failure(let error):
            throw error
        }
        
    }

    private func parse(_ input:String) -> Result {
        
        var inputMatrix = [[Int]]()
        let rows = input.components(separatedBy: "\n")
        var columnCount = 0
        var rowCount = 0
        
        // Loop through the rows delimited by (\n) new line character
        for row in rows {
            let trimmedRow = row.trimmingCharacters(in: .whitespaces)
            
            // No Input Check
            if(rowCount==0 && trimmedRow.isEmpty){
                return Result.failure(CustomError.noData)
            }
            
            rowCount = rowCount + 1
            
            if(rowCount==rows.count && trimmedRow.isEmpty){
                return Result.success(inputMatrix)
            }
            
            // Parse  row for Columns delimited by space (" ")
            let columns = trimmedRow.components(separatedBy: " ")
            let currentRowColumnCount = columns.count;
            
            // Check for uneven columns except the first row
            if (columnCount>0 && currentRowColumnCount>0 && currentRowColumnCount != columnCount) {
                return Result.failure(CustomError.incorrectFormat)
            }
            
            columnCount = currentRowColumnCount;
            
            // Proceed only if we have columns to process
            if columns.count > 0 {
                var columnMatrix = [Int]()
                for column in columns {
                    // Check for non-numeric characters
                    if let convertedInt = Int(column) {
                        // Group all the columns together
                        columnMatrix.append(convertedInt)
                    } else {
                        return Result.failure(CustomError.incorrectFormat)
                    }
                }
                
                // Add grouped columns for rows
                inputMatrix.append(columnMatrix)
            }
        }
        
        //Validation success
        return Result.success(inputMatrix)
    }
    
    
    // Matrix cell index value
    func valueForIndex(index:(row:Int,column:Int)) -> Int? {
        guard index.row > -1 ,index.column > -1, index.row < numOfRows , index.column < numOfColumns else {
            return nil
        }
        return costMatrix.costValues![index.row][index.column]
    }
    
    // Check if matrix is traversed completly or not
    func processedTillEnd()->Bool {
        return columnsProcessed == numOfColumns
    }
    
    // Returns all the cell indicies (row,column) for given column.
    func cellIndiciesForColumn(column:Int) -> [(Int,Int)] {
        var columnIndex = [(Int,Int)]()
        for row in 0..<numOfRows {
            columnIndex.append((row,column))
        }
        return columnIndex
    }
    
    // Calculates the minimum costs for given cell Indicies
    func miniumumOfCellsFor(cellindices:([(Int,Int)])) -> (index:(row:Int,column:Int)? ,value:Int?){
        var cost:Int?
        var costIndex : (Int,Int)?
        
        var indicies = cellindices
        if(numOfRows==3){
            indicies = cellindices.reversed()
        }
        
        //Loop through the cell edges
        for cellIndex in indicies {
            if let cellCost = valueForIndex(index: cellIndex){
                //Check for nil cost
                if let minimumCost = cost {
                    if cellCost < minimumCost {
                        cost = cellCost
                        costIndex = cellIndex
                    }
                }
                    // Store cellcost and index if it nil.
                else{
                    cost = cellCost
                    costIndex = cellIndex
                }
            }
        }
        return (costIndex,cost)
    }
    
    //MARK: Cost Calculation
    //Calculates the minimum cost required for each row in given column
    //Returns the processed costs and indicator for threshhold limit
    func processColumn(column:Int) -> ([Int],proceedNext:Bool){
        var columnCosts = [Int]()
        var proceedNext = true
        
        //Loop through all rows in particular column
        for currentRow in 0..<numOfRows {
            
            //Value for particualr row and column
            var currentIndexCost = valueForIndex(index: (currentRow,column))!
            
            //Get possible cell edges (Top,Straight,Bottom) for specific cell index
            if let cellEdges = backwardAdjacentCells(For: (currentRow,column)) {
                
                //Get minimum cost of given cell Edges.
                let minimumCellDetails = miniumumOfCellsFor(cellindices:cellEdges)
                let minimumEdgeCost = minimumCellDetails.value
                
                //Calculate cost to reach the particualr cell index
                currentIndexCost = currentIndexCost + minimumEdgeCost!
            }
            // Append cost of particular row
            columnCosts.append(currentIndexCost)
        }
        
        //Replace the column costs with processed column costs.
        replaceColumnCosts(for: column, withcosts: columnCosts)
        
        //Check if we have reached threshhold limit
        let minimumColumnCost = minimumCostForColumn(column: column)
        
        let abandonedCondition = 50
        if(minimumColumnCost.value! <= abandonedCondition) {
            columnsProcessed = columnsProcessed + 1
        } else {
            proceedNext = false
        }
        
        //returns the processed costs for column and indicator to proceednext.
        return (columnCosts, proceedNext)
    }
    
    // Internal function to replacecosts in particular column
    private func replaceColumnCosts(for column:Int , withcosts costs:[Int]) {
        for row in 0..<numOfRows {
            costMatrix.costValues?[row][column] = costs[row]
        }
    }
    
    //MARK: Shortest Path
    // traverse the matrix from last processed column to the first column (reverse order)
    // apply rules while traversing to get the minimum cost and return the path's cost.
    func traceShortestPath() -> (path:[(Int,Int)],cost:Int,pathExists:Bool)? {
        
        //Check for valid input
        guard costMatrix.costValues != nil , columnsProcessed > 0 else{
            return nil
        }
        
        //Get the starting point to traverse in reverse order.
        let lastColumnMinimumCostDetails = minimumCostForColumn(column: columnsProcessed-1)
        var currentIndex = lastColumnMinimumCostDetails.index!
        let minimumCost = lastColumnMinimumCostDetails.value
        
        //init path and store the last column
        var path = [(Int,Int)]()
        path.append(currentIndex)
        
        //loop through all columns until the first column is reached
        while currentIndex.column > 0 {
            
            //Get the adjacent cell edges for given cell index (row,column)
            let cells = backwardAdjacentCells(For: currentIndex)
            
            //Calculate the min cost for given cell edges
            let minimumCellDetails = miniumumOfCellsFor(cellindices: cells!)
            currentIndex = minimumCellDetails.index!
            
            //Store the min cost cell index in the path.
            path.append(currentIndex)
        }
        
        // Matrix traversed in reverse direction, so reverse the path.
        path = path.reversed()
        
        //Check if matrix is processed till end or not
        let pathExists = processedTillEnd()
        return (path,minimumCost!,pathExists)
    }
    
    
    // Calculates the minimum cost for given column by checking for its adjacent cell edges.
    func minimumCostForColumn(column:Int) -> (index:(row:Int,column:Int)? ,value:Int?) {
        // Get adjacent cell edges.
        let columnIndicies = cellIndiciesForColumn(column: column)
        // Calculate the minimum cost for given cell edges
        let minimumCostDetails = miniumumOfCellsFor(cellindices: columnIndicies)
        return minimumCostDetails
    }
    
    //MARK: Cell Edges
    //Returns top, staight, and bottom cell indicies for given cellIndex in reverse order
    func backwardAdjacentCells(For cellIndex:(row:Int,column:Int)) -> ([(Int,Int)]?)  {
        
        guard costMatrix.costValues != nil , cellIndex.row > -1 ,cellIndex.column > 0 else {
            return nil
        }
        
        // Straight cell index
        let straight = (cellIndex.row,cellIndex.column-1)
        
        // Calculate the Diagonal Top index
        var diagonalTop = (cellIndex.row-1,cellIndex.column-1)
        // If its first row, then proceed to last row
        if cellIndex.row == 0 {
            diagonalTop = (numOfRows-1,cellIndex.column-1)
        }
        
        // Calculate the Diagonal bottom index
        var diagonalBottom = (cellIndex.row+1,cellIndex.column-1)
        // If its last row, then proceed to first row
        if cellIndex.row == numOfRows-1 {
            diagonalBottom = (0,cellIndex.column-1)
        }
        
        // Group the cell edges
        let adjacentCells = [diagonalTop,straight,diagonalBottom]
        return adjacentCells
    }
    
    //Calculates Minimum cost
    func calculateMinimumCost()->(path:[Int],cost:Int,pathCompleted:Bool)?{
        
        //Return if matrix or values are nil
        guard costMatrix != nil, costMatrix!.costValues != nil else{
            return nil
        }
        
        // Calculate all columns costs
        for currentColumn in 0..<costMatrix!.numberOfColumns{
            
            // Checks for least possbile cost for all rows in particular column
            let columnCosts = processColumn(column: currentColumn)
            
            //Stop execution when threadhold limit has reached.
            if columnCosts.proceedNext == false {
                break
            }
        }
        
        //Traces the minimum path on the processed Matrix
        if let minimumCostDetails = traceShortestPath() {
            let paths = minimumCostDetails.path
            //Processes only the rows, ignore the columns
            var rowDetails = [Int]()
            for path in paths {
                rowDetails.append(path.0+1)
            }
            return(rowDetails,minimumCostDetails.cost,minimumCostDetails.pathExists)
        }
        
        //Didnt move from first column
        return([],0,false)
    }


}

