//
//  SampleInputTableViewController.swift
//  LowestCostPath
//
//  Created by Seab on 04/22/17.
//  Copyright © 2017 NA. All rights reserved.
//

import UIKit



class SampleInputTableViewController: UITableViewController {
    
    private var inputValues = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleInputsLabels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sampleInputsLabels[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputValues = sampleCostValues[indexPath.row]
        self.performSegue(withIdentifier: "costDetailsSegue", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewController = segue.destination as! CostDetailsViewController
        viewController.inputValues = inputValues
    }


}
