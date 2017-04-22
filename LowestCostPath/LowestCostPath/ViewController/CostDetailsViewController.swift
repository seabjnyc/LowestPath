//
//  CostDetailsViewController.swift
//  LowestCostPath
//
//  Created by Seab on 04/22/17.
//  Copyright © 2017 NA. All rights reserved.
//

import UIKit

class CostDetailsViewController: UIViewController {
    
    @IBOutlet weak var leastCostPath: UILabel!
    @IBOutlet weak var leastCost: UILabel!
    @IBOutlet weak var pathExists: UILabel!
    @IBOutlet weak var costInputsView: UITextView!
    
    var inputValues = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pre load the text view based on input values passed through segue
        costInputsView.text = inputValues
        
        
        // Process the input values and check for least cost
        do {
            let handler = try MatrixHandler(with: inputValues)
            if let result = handler.calculateMinimumCost() {
                
                // Set the results accordingly.
                pathExists.text = "Path Exists: " + (result.pathCompleted ? "Yes":"No")
                leastCost.text = "Total Cost: " +  "\(result.cost)"
                leastCostPath.text = "Total Cost: " + "\(result.path)"
            }
        }
        // Check for Invalid or No input conditions
        catch let error {
            pathExists.text = error.localizedDescription
            leastCost.text = ""
            leastCostPath.text = ""

        }
    }
}
