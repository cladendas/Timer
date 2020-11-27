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
    
    private var notificationCenter = NotificationCenter.default
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : String]()
    
    var roundsTrain: [Double] = [2.0, 24.0, 13]
    
    ///Интервалы
    var roundsTrainQ = [[Double]]()
    var roundsQ = [[3.0], [4.0, 5.0, 6.0]]
    ///Хранит в чистом виде данные из ViewControllerOptionsTrain: кол-во раундов, повторения и/или временные интервалы
    var roundsQQ = [[Any]]()
    ///Тренировка: временные интервалы и/или кол-во повторений
    var roundsTrainQQ = [[Any]]()
    
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
    
    var viewControllerOptionsTrain = ViewControllerOptionsTrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfRep.isHidden = true
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        nextButton.isHidden = true
        
        tableOfTrain.delegate = self
        tableOfTrain.dataSource = self
        
        tmpRoundsTrain = roundsTrain
        countNumOfTrains = roundsTrain.count

        timeForRound = findTime()
    }
    
    ///Поиск в тренировке временного интервала и инициалищация его значением перемнной для таймера
    func findTime() -> Double {
        for section in roundsTrainQQ {
            for item in section {
                if item is Double {
                    timeForRound = item as! Double
                    return timeForRound
                }
            }
        }
        
        return 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewControllerOptionsTrain.clouserTableTrain = { [unowned self] item in
            let ff = item[0][0] as! Int
            self.numOfRounds = ff
            self.roundsQQ = item
            self.roundsTrainQQ = Array(repeating: item[1], count: ff)
            self.tableOfTrain.reloadData()
        }
        timeForRound = findTime()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if case let controller as ViewControllerOptionsTrain = segue.destination, segue.identifier == "OptionsTimer" {
        viewControllerOptionsTrain = controller
        }
        timeForRound = findTime()

//        SaverLoader.save(value: roundsTrainQQ, for: "train")
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        numberOfRep.isHidden = false
        optionsBarItem.isEnabled = false
        
//        if roundsTrainQQ[0][0] is Double {
//            timerForTrain = timer()
//        } else if roundsTrainQQ[0][0] is Int {
//            nextButton.isHidden = false
//        }
        
        timerForTrain = timer()
        
    }
    
    @IBOutlet var nextButton: UIButton!
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        nextButton.isHidden = true
        roundsTrainQQ[0].remove(at: 0)
        tableOfTrain.reloadData()
        
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
                print(roundsTrainQ[0][0])
                timeForRound = roundsTrainQ[0][0]
                
                let ip = IndexPath(row: 0, section: 0)
                roundsTrainQ[0].remove(at: 0)
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
        return roundsTrainQQ.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsTrainQQ[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)

        if roundsTrainQQ[indexPath.section][indexPath.row] is Double {
            let time = TimeFormatter.formatter(time: roundsTrainQQ[indexPath.section][indexPath.row] as! Double)
            
            cell.textLabel?.text = "\(time)"
            return cell
        } else if roundsTrainQQ[indexPath.section][indexPath.row] is Int {
            let time = roundsTrainQQ[indexPath.section][indexPath.row] as! Int
            
            cell.textLabel?.text = "Повторов: \(time)"
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Раунд \(section + 1)"
    }
}
