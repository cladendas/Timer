//
//  ViewControllerTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerTrain: UIViewController {
    
    @IBOutlet var optionsBarItem: UIBarButtonItem!
    @IBOutlet var timer: UILabel!
    @IBOutlet var numberOfRep: UILabel!
    
    @IBOutlet var stop: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var start: UIButton!
    @IBOutlet var continueLabel: UIButton!
    @IBOutlet var rep: UIButton!
    
    @IBOutlet var tableOfTrain: UITableView!
    
    var roundsTrain: [Double] = [2.0, 24.0]
    var vcOptionTrain = ViewControllerOptionsTrain()
    
    var numOfRounds = 0
    var countRep = 0
    
    var timerForTrain = Timer()
    ///Время для таймера раунда (максимум 5999.99)
    private var timeForRound: Double = 1.0
    ///Переменная для хранения начального значения времени таймера раунда (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfRep.isHidden = true
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        
        tableOfTrain.delegate = self
        tableOfTrain.dataSource = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if case let controller as ViewControllerOptionsTrain = segue.destination, segue.identifier == "OptionsTimer" {
                controller.clouserNumOfRounds = { [unowned self] num in
                    self.numOfRounds = num
                    self.tableOfTrain.reloadData()
                }
                controller.clouserRounds = { [unowned self] rounds in
                    self.roundsTrain = rounds
                }
            }
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        numberOfRep.isHidden = false
        optionsBarItem.isEnabled = false
        
        timerForTrain = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        
//        currentTimeOfRound = timeForRound
//        currentTimeOfRes = timeForRes
//        
//        timerForRound.invalidate()
//        timerForRes.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        continueLabel.isHidden = true

//        if timeForRound != tmpTimeForRound {
//            timeForRound = currentTimeOfRound
//
//            timerForRound = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
//
//            currentTimeOfRound = 00.00
//        }
//
//        if timeForRes != tmpTimeForRes {
//            timeForRes = currentTimeOfRes
//
//            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRes), userInfo: nil, repeats: true)
//
//            currentTimeOfRes = 00.00
//        }
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
//        timerForRound.invalidate()
//        timerForRes.invalidate()
        
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rep.isHidden = true
        rep.isHidden = true
        continueLabel.isHidden = true
        optionsBarItem.isEnabled = true
        
//        timeForRound = tmpTimeForRound
//        timeForRes = tmpTimeForRes
//        countOfRounds = tmpCountOfRounds
//        timeLabel.text = TimeFormatter.formatter(time: timeForRound)
//        timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
//        numberOfRounds.text = "Раундов \(countOfRounds)/\(countOfRounds)"
    }
    
    ///Подсчёт повторений. Здесь погрешность в том, если будут выполняться какие-то быстрые двжения, требующие подсчёта (прыжки на скакалке, выбросы грифа, полуприседы). Обработка нажатия на кнопку не успевает. Подсчёт работает и во время отдыха
    @IBAction func repAction(_ sender: UIButton) {
        countRep += 1
        numberOfRep.text = "\(countRep)"
        
        changeViewBackground()
    }
    
    ///Анимация, которая меняет цвет фона, чтобы пользователь мог увидеть, что кнопка "Повтор" была нажата
    ///Как развитие: можно сделать подсчёт повторений по голосовой команде или при включённом видео, которое анализируется и ведётся подсчёт повторений
    private func changeViewBackground() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .blue
        }) { (anim) in
            self.view.backgroundColor = .black
        }
    }
    
    @objc
    private func timerUpdateForRound() {
        timeForRound -= 00.01
//        if timeForRound <= 0.0 && countOfRounds > 0 {
//            timerForRound.invalidate()
//            //чтобы таймер стратовал с заданного значения
//            timeForRound = tmpTimeForRound
//            countOfRounds -= 1
//            
//            numberOfRounds.text = "Раундов \(countOfRounds)/\(tmpCountOfRounds)"
//            
//            startRes()
//        } else {
//            timer.text = TimeFormatter.formatter(time: timeForRound)
//        }
    }

}

extension ViewControllerTrain: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return numOfRounds
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsTrain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)
        
        let time = TimeFormatter.formatter(time: roundsTrain[indexPath.row])
        
        cell.textLabel?.text = time

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Раунд \(section + 1)"
    }
}
