//
//  ViewControllerRounds.swift
//  Timer
//
//  Created by cladendas on 14.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

///Класс для настройки контроллера с параметрами для кол-ва раундов, времени раунда и отдыха
class ViewControllerRounds: UIViewController {
    
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var timeForRound: UILabel!
    @IBOutlet var timeForRes: UILabel!
    @IBOutlet var tableRounds: UITableView!
    
    @IBOutlet var stepperForRound: UIStepper!
    @IBOutlet var stepperForTimeForRound: UIStepper!
    @IBOutlet var stepperForTimeRes: UIStepper!
    
    
    ///Кол-во раундов
    var clouserNumOfRounds: ((Int) -> Void)?
    ///Время раунда
    var clouserTimeForRound: ((Double) -> Void)?
    ///Время отдыха
    var clouserTimeForRes: ((Double) -> Void)?
    
    let firstRound = [1.0, 10.0, 5.0]
    
    var rr = [[Double]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableRounds.delegate = self
        tableRounds.dataSource = self
        
        rr.append(firstRound)

        clouserNumOfRounds?(1)
        clouserTimeForRound?(5.0)
        clouserTimeForRes?(5.0)
    }
    
    @IBAction func addRounds(_ sender: UIBarButtonItem) {
        
        rr.append([stepperForRound.value, stepperForTimeForRound.value, stepperForTimeForRound.value])
        
        tableRounds.reloadData()
    }
    
    
    @IBAction func stepperForNumForRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        clouserNumOfRounds?(tmpValue)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
    }
    
    @IBAction func stepperForTimeForRoundsAction(_ sender: UIStepper) {
        let tmpValue = TimeFormatter.formatter(time: sender.value)
        clouserTimeForRound?(sender.value)
        timeForRound.text = "Время раунда: \(tmpValue)"
    }
    
    @IBAction func stepperForTimeForResAction(_ sender: UIStepper) {
        let tmpValue = TimeFormatter.formatter(time: sender.value)
        clouserTimeForRes?(sender.value)
        timeForRes.text = "Время отдыха: \(tmpValue)"
    }
}

extension ViewControllerRounds: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRounds", for: indexPath)
        
        let row = gg(round: rr[indexPath.row][0], timeForRound: rr[indexPath.row][1], timeForRes: rr[indexPath.row][2])
        
        cell.textLabel?.text = "\(row[1]) - \(row[2]) /\(row[0])"
        
        return cell
    }
    
    func gg(round: Double, timeForRound: Double, timeForRes: Double) -> [String] {
        
        let round = String(Int(round))
        let timeForRound = TimeFormatter.formatter(time: timeForRound)
        let timeForRes = TimeFormatter.formatter(time: timeForRes)
        
        return [round, timeForRound, timeForRes]
    }
    
    
}
