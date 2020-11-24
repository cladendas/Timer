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

    ///Тренировка представлена в виде кол-ва раундов (здесь элемент под индексом 0) и временными интервалами (здесь элемент массива, который под индексом 1)
    var roundsQ = [[Double]]()
    var roundsQQ: [[Any]] = [[1], [5.0, 4, 10.0]]

    var stepperRoundValue = 5.0

    var clouserRoundsQ: (([[Double]]) -> Void)?
    var clouserQ: (([[Any]]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self
        
        if let data = SaverLoader.load(for: "train") {
            roundsQQ = data as! [[Any]]
//            numberOfRounds.text = "Кол-во раундов: \(roundsQQ[0][0] as! Int)"
            clouserRoundsQ?(roundsQ)
        } else {
            roundsQQ = []
        }
        
//        roundsQQ = [[2], [2.0, 12, 4.0, 14]]
    }
    
    @IBAction func addTimeAction(_ sender: Any) {
//        roundsQ[1].append(stepperRoundValue)
        roundsQQ[1].append(stepperRoundValue)
        tableOfTrain.reloadData()
        clouserRoundsQ?(roundsQ)
        
        clouserQ?(roundsQQ)
        
        SaverLoader.save(value: roundsQQ, for: "train")
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        roundsQQ[0] = [Int(sender.value)]
        clouserRoundsQ?(roundsQ)
        
        clouserQ?(roundsQQ)
    }

}

extension ViewControllerOptionsTrain: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsQQ[1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTrain
        
//        cell.clouserStepperTime = { item in
//            self.roundsQ[1][indexPath.row] = item
//            self.clouserRoundsQ?(self.roundsQ)
//        }
        
        cell.clouserQ = { item in
            self.roundsQQ[1][indexPath.row] = item
            self.clouserQ?(self.roundsQQ)
        }
        
        return cell
    } 
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            roundsQQ[1].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableOfTrain.reloadData()
            SaverLoader.save(value: roundsQQ, for: "train")
        }
    }
}
