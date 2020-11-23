//
//  ViewControllerOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerOptionsTrain: UIViewController {
    
    @IBOutlet var tableOfTrain: UITableView!
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var stepperNumOfRounds: UIStepper!

    var roundsQ = [[Double]]()

    var stepperRoundValue = 5.0

    var clouserRoundsQ: (([[Double]]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self
        
        let ss = [[3.0], [2.0, 3.0, 4.0]]
        roundsQ = ss
        clouserRoundsQ?(ss)
    }
    
    @IBAction func addTimeAction(_ sender: Any) {
        roundsQ[1].append(stepperRoundValue)
        tableOfTrain.reloadData()
        SaverLoader.save(value: roundsQ, for: "train")
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        roundsQ[0] = [sender.value]
        clouserRoundsQ?(roundsQ)
    }

}

extension ViewControllerOptionsTrain: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsQ[1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTrain
        
        return cell
    } 
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            roundsQ[1].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SaverLoader.save(value: roundsQ, for: "train")
        }
    }
}
