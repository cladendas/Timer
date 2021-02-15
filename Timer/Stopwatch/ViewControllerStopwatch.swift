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
    
    ///Текущее время
    var currentDate = Date()
    ///Временной интервал
    ///- Используется при расчётах времени
    var timeInterval = 0.0
    ///Переменная для фиксации текущего значения временного интервала
    var tmpTimeInterval: Double = 00.00

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var start: UIButton!
    @IBOutlet var round: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var continueLabel: UIButton!
    @IBOutlet var tableViewRounds: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        round.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        
        tableViewRounds.delegate = self
        tableViewRounds.dataSource = self
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(
        ofSize: 70, weight: .regular)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        round.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        
        currentDate = Date()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: Date(), repeats: true)
        
        //Позволяет обрабатывать события в интерфейсе. Здесь: чтобы скроллинг таблицы не останавливает таймер
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @IBAction func roundAction(_ sender: UIButton) {
        let round = timeLabel.text ?? "00:00:00"
        rounds.insert(round, at: 0)
        tableViewRounds.reloadData()
        
        currentDate = Date()
        timeInterval = 0.0
        timerUpdate()
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        round.isHidden = true
        pause.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        tmpTimeInterval = timeInterval
        timer.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        round.isHidden = false
        pause.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        timerUpdate()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        start.isHidden = false
        continueLabel.isHidden = true
        stop.isHidden = true
        
        timer.invalidate()
        tmpTimeInterval = 00.00
        
        timeLabel.text = "00:00:00"
        rounds = []
        tableViewRounds.reloadData()
    }
    
    @objc
    func timerUpdate() {
        timeInterval = -currentDate.timeIntervalSinceNow + tmpTimeInterval
        timeLabel.text = TimeFormatter.formatterQ(interval: timeInterval)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellStopwatch

        var isTheBest = ""
        
        if rounds[indexPath.row] == rounds.min() {
            isTheBest = "Лучший"
        } else if rounds[indexPath.row] == rounds.max() {
            isTheBest = "Худший"
        }
        
        //Фиксация времен круга идёт в формате "номер круга) MM:ss:msms
        //Номер круга выводится, как результат разницы rounds.count - indexPath.row
        cell.initCell(round: "\(rounds.count - indexPath.row)", time: "\(rounds[indexPath.row])", isTheBest: isTheBest)
        
        return cell
    }
}

