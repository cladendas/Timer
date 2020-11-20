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
    var currentTime: Double = 00.00
    ///Переменная для фиксации значения текущего времени
    var tmpTime: Double = 00.00

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
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: Date(), repeats: true)
        
        //Позволяет обрабатывать события в интерфейсе. Здесь: чтобы скроллинг таблицы не останавливает таймер
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    //Когда свайпишь таблицу с кругами, то отсчёт времени останавливается, а когда отпускаешь - время идёд дальше, а таблица при нажатии на кнопку "Круг" не пролистывается к последнему значению
    @IBAction func roundAction(_ sender: UIButton) {
        let round = TimeFormatter.formatter(time: currentTime)
        rounds.insert(round, at: 0)
        tableViewRounds.reloadData()
        
        currentTime = tmpTime
        timerUpdate()
        tmpTime = 00.00
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        round.isHidden = true
        pause.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        tmpTime = currentTime
        timer.invalidate()
        
        timeLabel.text = TimeFormatter.formatter(time: currentTime)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        round.isHidden = false
        pause.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        currentTime = tmpTime
        timerUpdate()
        tmpTime = 00.00
    }
    
    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        start.isHidden = false
        continueLabel.isHidden = true
        stop.isHidden = true
        
        timer.invalidate()
        currentTime = 00.00
        tmpTime = 00.00
        
        timeLabel.text = "00:00:00"
        rounds = []
        tableViewRounds.reloadData()
    }
    
    @objc
    func timerUpdate() {
        currentTime += 00.01
        timeLabel.text = TimeFormatter.formatter(time: currentTime)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellStopwatch

        //Фиксация времен круга идёт в формате "номер круга) MM:ss:msms
        //Номер круга выводится, как результат разницы rounds.count - indexPath.row
        let tmpRound = "\(rounds.count - indexPath.row) круг"
        let tmpTime = "\(rounds[indexPath.row])"
        var tmpBest = ""
        
        if rounds[indexPath.row] == rounds.min() {
            tmpBest = "Лучший"
        } else if rounds[indexPath.row] == rounds.max() {
            tmpBest = "Худший"
        }
        
        cell.initCell(round: tmpRound, time: tmpTime, best: tmpBest)
        
        return cell
    }
}

