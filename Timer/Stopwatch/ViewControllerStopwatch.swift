//
//  ViewControllerStopwatch.swift
//  Timer
//
//  Created by cladendas on 12.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerStopwatch: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rounds: [String] = []
    var timer = Timer()
    
    var tmpTimeInterval: Float = 00.00

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var start: UIButton!
    @IBOutlet var round: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var tableViewRounds: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        round.isHidden = true
        stop.isHidden = true
        
        tableViewRounds.delegate = self
        tableViewRounds.dataSource = self
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        round.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    //Когда свайпишь таблицу с кругами, то отсчёт времени останавливается, а когда отпускаешь - время идёд дальше, а таблица при нажатии на кнопку "Круг" не пролистывается к последнему значению
    @IBAction func roundAction(_ sender: UIButton) {
        let round = TimeFormatter.formatter(time: tmpTimeInterval)
        rounds.insert(round, at: 0)
        tableViewRounds.reloadData()
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        round.isHidden = true
        pause.isHidden = true
        stop.isHidden = false
        start.isHidden = false
        
        timer.invalidate()
        
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
    }

    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        start.isHidden = false
        
        timer.invalidate()
        tmpTimeInterval = 00.00
        
        timeLabel.text = "00:00:00"
        rounds = []
        tableViewRounds.reloadData()
    }
    
    @objc
    func timerUpdate() {
        tmpTimeInterval += 00.01
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //Фиксация времен круга идёт в формате "номер круга) MM:ss:msms
        //Номер круга выводится, как результат разницы rounds.count - indexPath.row
        //Не разобрался, почему если номер круга обозначать, как rounds.count, то это значениче выставляется во всех ячейках
        cell.textLabel?.text = "\(rounds.count - indexPath.row)) \(rounds[indexPath.row])"
        
        return cell
    }
}

