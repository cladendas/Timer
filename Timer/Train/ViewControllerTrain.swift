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
    @IBOutlet var time: UILabel!
    @IBOutlet var numberOfRep: UILabel!
    
    @IBOutlet var stop: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var start: UIButton!
    @IBOutlet var continueLabel: UIButton!
    @IBOutlet var rep: UIButton!
    
    @IBOutlet var tableOfTrain: UITableView!
    
    var roundsTrain: [Double] = [2.0, 24.0, 13]
    
    ///Интервалы
    var roundsTrainQ = [[Double]]()
    var roundsQ = [[3.0], [4.0, 5.0, 6.0]]
    
    var tmpRoundsTrain: [Double] = []
    
    var numOfRounds = 0
    var countNumOfTrains = 0
    var countRep = 0
    
    var timerForTrain = Timer()
    ///Время для таймера раунда (максимум 5999.99)
    private var timeForRound: Double = 10.0
    ///Переменная для хранения начального значения времени таймера раунда (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    ///Переменная для фиксации значения текущего времени
    var tmpTime: Double = 00.00
    ///Текущее время раунда
    var currentTimeOfRound: Double = 00.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfRep.isHidden = true
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        
        tableOfTrain.delegate = self
        tableOfTrain.dataSource = self
        
        timeForRound = roundsQ[0][0]
        tmpTimeForRound = timeForRound
        tmpRoundsTrain = roundsTrain
        countNumOfTrains = roundsTrain.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if case let controller as ViewControllerOptionsTrain = segue.destination, segue.identifier == "OptionsTimer" {
//            controller.clouserNumOfRounds = { [unowned self] num in
//                self.numOfRounds = num
//                self.tableOfTrain.reloadData()
//            }
//            controller.clouserRounds = { [unowned self] rounds in
//                self.roundsTrain = rounds
//                self.timeForRound = self.roundsTrain[0]
//                self.time.text = TimeFormatter.formatter(time: self.roundsTrain[0])
//                self.tableOfTrain.reloadData()
//            }
            controller.clouserRoundsQ = { [unowned self] item in
                self.numOfRounds = Int(item[0][0])
                self.roundsQ = item
//                self.roundsTrainQ = Array(repeating: item[1], count: Int(item[0][0]))
                self.time.text = TimeFormatter.formatter(time: self.roundsTrainQ[1][0])
                self.tableOfTrain.reloadData()
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
        
        timerForTrain = timer()
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        
        currentTimeOfRound = timeForRound
        
        timerForTrain.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        continueLabel.isHidden = true
        
        if timeForRound != tmpTimeForRound {
            timeForRound = currentTimeOfRound

            timerForTrain = timer()

            currentTimeOfRound = 00.00
        }
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        timerForTrain.invalidate()
        
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        numberOfRep.isHidden = true
        rep.isHidden = true
        continueLabel.isHidden = true
        optionsBarItem.isEnabled = true
        
        timeForRound = tmpTimeForRound
        time.text = TimeFormatter.formatter(time: timeForRound)
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
        if timeForRound <= 0.0 {
            timerForTrain.invalidate()
            
            //чтобы таймер стартовал с заданного значения
            if roundsTrain.count > 1 {
                timeForRound = roundsQ[0][1]
                
                let ip = IndexPath(row: 0, section: 0)
                roundsQ[0].remove(at: 0)
                tableOfTrain.deleteRows(at: [ip], with: .fade)

                tableOfTrain.reloadData()
                
                timerForTrain = timer()
            } else if roundsTrain.count == 1 {
                if let first = roundsTrain.first {
                    timeForRound = first
                }
//                roundsTrain.removeFirst()
                
//                let ip = IndexPath(row: 0, section: 0)
//                tableOfTrain.deleteRows(at: [ip], with: .fade)
                
                tableOfTrain.reloadData()
                
                timerForTrain = timer()
            }

        } else if roundsTrain.count == 0  {
            timerForTrain.invalidate()
            roundsTrain = tmpRoundsTrain
            tableOfTrain.reloadData()
            time.text = TimeFormatter.formatter(time: timeForRound)
        } else {
            time.text = TimeFormatter.formatter(time: timeForRound)
        }
    }
    
    ///Для создания таймера для отсчёта времени
    private func timer() -> Timer {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
}

extension ViewControllerTrain: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return roundsTrainQ.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsTrainQ[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)
        
        let time = TimeFormatter.formatter(time: roundsTrainQ[indexPath.section][indexPath.row])
        
        cell.textLabel?.text = time
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Раунд \(section + 1)"
    }
}
