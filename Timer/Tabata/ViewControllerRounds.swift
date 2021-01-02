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
    
    ///Хранит данные о кол-ве раундов [0], времени раунда [1], времени отдыха [2]
    var rounds = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableRounds.delegate = self
        tableRounds.dataSource = self
        
        clouserNumOfRounds?(1)
        clouserTimeForRound?(5.0)
        clouserTimeForRes?(5.0)

        if let data = SaverLoader.load(for: "rounds") {
            rounds = data
        } else {
            rounds = []
        }
    }
    
    func convToString(_ value: Any) -> String {
        return "\(value)"
    }
    
    @IBAction func addRounds(_ sender: UIBarButtonItem) {
        
        rounds.append([convToString(stepperForRound.value), convToString(stepperForTimeForRound.value), convToString(stepperForTimeRes.value)])
        
        tableRounds.reloadData()
        
        SaverLoader.save(value: rounds, for: "rounds")
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
    
    ///Преобразует в [String] данные о кол-ве раундов, времени раунда, времени отдыха
    func formatInfoRound(round: String, timeForRound: String, timeForRes: String) -> [String] {

        let tmpRound = Int(Double(round) ?? 0.0)
        let tmpTimeForRound = Double(timeForRound) ?? 0.0
        let tmpTimeForRes = Double(timeForRes) ?? 0.0
        
        let round = String(tmpRound)
        let timeForRound = TimeFormatter.formatter(time: tmpTimeForRound)
        let timeForRes = TimeFormatter.formatter(time: tmpTimeForRes)
        
        return [round, timeForRound, timeForRes]
    }
}

extension ViewControllerRounds: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRounds", for: indexPath)
        
        let row = formatInfoRound(round: rounds[indexPath.row][0], timeForRound: rounds[indexPath.row][1], timeForRes: rounds[indexPath.row][2])
        
        cell.textLabel?.text = "\(row[1]) - \(row[2]) /\(row[0])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ff = formatInfoRound(round: rounds[indexPath.row][0], timeForRound: rounds[indexPath.row][1], timeForRes: rounds[indexPath.row][2])
        
        clouserNumOfRounds?(rounds[indexPath.row][0] as! Int)
        clouserTimeForRound?(Double(rounds[indexPath.row][1]) as! Double)
        clouserTimeForRes?(rounds[indexPath.row][2] as! Double)
        
        numberOfRounds.text = "Кол-во раундов: \(ff[0])"
        timeForRound.text = "Время раунда: \(ff[1])"
        timeForRes.text = "Время отдыха: \(ff[2])"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rounds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SaverLoader.save(value: rounds, for: "rounds")
        }
    }
}
