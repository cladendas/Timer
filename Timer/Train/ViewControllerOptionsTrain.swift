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
    
    var rounds = [Double]()
    var countOfRounds = 1
    var stepperRoundValue = 5.0
    
    var clouserRounds: (([Double]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self

        clouserRounds?(rounds)
        
        if let data = SaverLoader.load(for: "train") {
            rounds = data as! [Double]
        } else {
            rounds = []
        }
    }
    
    @IBAction func addTimeAction(_ sender: Any) {
        rounds.append(stepperRoundValue)
        tableOfTrain.reloadData()
        SaverLoader.save(value: rounds, for: "train")
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
//        clouserNumOfRounds?(tmpValue)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewControllerOptionsTrain: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTrain
        
        let tmpInterval = TimeFormatter.formatter(time: rounds[indexPath.row])
        
        cell.initCell(time: "Интервал \(tmpInterval)")
        
        return cell
    } 
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rounds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            saveData()
        }
    }
}
