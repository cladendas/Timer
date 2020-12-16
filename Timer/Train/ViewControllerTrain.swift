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
    ///Лэйбл текущего интервала
    @IBOutlet var time: UILabel!
    ///Кол-во повторений
    @IBOutlet var numberOfRep: UILabel!
    
    @IBOutlet var stop: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var start: UIButton!
    ///Продолжить работу таймера после паузы
    @IBOutlet var continueLabel: UIButton!
    @IBOutlet var rep: UIButton!
    ///Следующий интервал. Доступна только при работе интервала повторений
    @IBOutlet var nextButton: UIButton!
    
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
    var roundsTrainQQ: [[String]]?
    
    var tmpRoundsTrain: [Double] = []
    
    var numOfRounds = 0
    var countNumOfTrains = 0
    var countRep = 0
    
    ///Таймер
    var timerForTrain = Timer()
    ///Хранит временной интервал (максимум 5999.99)
    private var timeForRound: Double = 10.0
    ///Хранит начальное значение временного интервала из переменной  timeForRound (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    ///Хранит текущее значение временного интервала
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
        
        self.time.font = UIFont.monospacedDigitSystemFont(
        ofSize: 70, weight: .regular)
        
        tableOfTrain.delegate = self
        tableOfTrain.dataSource = self
        
        tmpRoundsTrain = roundsTrain
        countNumOfTrains = roundsTrain.count
        
        if let data = SaverLoader.load(for: "train") {
            self.roundsTrainQQ = data
            self.numOfRounds = data.count
            tableOfTrain.reloadData()
        }
        
        changeFontForTimeLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(getNotification), name: .train, object: nil)
    }
    
    ///Поиск в тренировке временного интервала
    ///- Возвращается первое попавшееся значение
    private func findTime() -> Double {
        
        guard let tmpRoundsTrainQQ = roundsTrainQQ else { return 0.0 }
        
        var tmpTime = 0.0
        
        for section in tmpRoundsTrainQQ {
            for item in section {
                if item.contains(".") {
                    tmpTime = Double(item) ?? 0.0
                    return tmpTime
                }
            }
        }
        
        return tmpTime
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
//    func checkTimeOrExercise() -> String {
//
//        let dd = checkTypeInterval()
//
//        if dd.keys.contains("time") {
//            return "time"
//        } else if dd.keys.contains("exercise") {
//            return "exercise"
//        }
//
//        return "-1"
//    }
    
    ///Проверка типа интервала первого элемента. Возвращает словарь: в ключе тип интервала (time, exercise) и соответствующее значение
    ///- В блоке guard проверится наличие первого элемента в первом секторе
    private func checkTypeInterval() -> [String: String] {
        
        guard let first = roundsTrainQQ?[0].first, let _ = roundsTrainQQ else { return ["finish" : "0"] }
        
        if first.contains(".") {
            return ["time" : first]
        } else {
            return ["exercise" : first]
        }
    }
    
    @objc
    func getNotification(notification: Notification) {
        guard let item = notification.userInfo as? [String: [[String]]] else { return }
        
        if let train = item["train"] {
            let numOfRounds = Int(train[0][0]) ?? 0
            self.numOfRounds = numOfRounds
            self.roundsTrainQQ = Array(repeating: train[1], count: self.numOfRounds)
        }
        self.tableOfTrain.reloadData()
        changeFontForTimeLabel()
        
        SaverLoader.save(value: self.roundsTrainQQ!, for: "train")
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        numberOfRep.isHidden = false
        optionsBarItem.isEnabled = false
        
        if let _ = checkTypeInterval()["time"] {
            pause.isHidden = false
            timerForTrain = timer()
        } else if let _ = checkTypeInterval()["exercise"] {
            pause.isHidden = true
            nextButton.isHidden = false
        }
    }
    
    ///У лейбла таймера выставит соотвествующее значение
    private func changeFontForTimeLabel() {
        if let time = checkTypeInterval()["time"] {
            let tmp = Double(time) ?? 0.0
            timeForRound = tmp
            tmpTimeForRound = tmp
            self.time.font = UIFont.monospacedDigitSystemFont(ofSize: 70, weight: .regular)
            self.time.text = TimeFormatter.formatter(time: tmp)
        } else if let exercise = checkTypeInterval()["exercise"] {
            self.time.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.regular)
            self.time.textAlignment = .justified
            self.time.text = "Повторов: \(exercise)"
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        roundsTrainQQ?[0].remove(at: 0)
        tableOfTrain.reloadData()
        
        if roundsTrainQQ?[0].count == 0 {
            roundsTrainQQ?.remove(at: 0)
            tableOfTrain.reloadData()
        }
        
        if roundsTrainQQ?.count == 0 {
            stopAction(stop)
            self.time.text = "Допрыгался!"
        } else if let time = checkTypeInterval()["time"] {
            nextButton.isHidden = true
            pause.isHidden = false
            timeForRound = Double(time) ?? 0.0
            timerForTrain = timer()
            
        } else if let exercise = checkTypeInterval()["exercise"] {
            nextButton.isHidden = false
            self.time.text = "Повторов: \(exercise)"
        }
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
        nextButton.isHidden = true
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
            
            roundsTrainQQ?[0].remove(at: 0)
            tableOfTrain.reloadData()
            
            if let time = checkTypeInterval()["time"] {
                pause.isHidden = false
                nextButton.isHidden = true
                timeForRound = Double(time) ?? 0.0
                timerForTrain = timer()
            } else if let exercise = checkTypeInterval()["exercise"] {
                pause.isHidden = true
                nextButton.isHidden = false
                self.time.text = "Повторов: \(exercise)"
            }
            
//            if roundsTrainQQ?[0].count == 0 {
//                roundsTrainQQ?.remove(at: 0)
//                tableOfTrain.reloadData()
//            }
            
            if roundsTrainQQ?.count == 0 {
                stopAction(stop)
                self.time.text = "Допрыгался!"
            }

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
        
        guard let tmpRoundsTrainQQ = roundsTrainQQ else { return 0 }
        
        return tmpRoundsTrainQQ.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tmpRoundsTrainQQ = roundsTrainQQ else { return 0 }
        
        return tmpRoundsTrainQQ[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)

        guard let tmpRoundsTrainQQ = roundsTrainQQ else { return UITableViewCell() }
        
        let tmpInterval = tmpRoundsTrainQQ[indexPath.section][indexPath.row]
        
        if tmpInterval.contains(".") {
            let tmpDouble = Double(tmpInterval) ?? 0.0
            let time = TimeFormatter.formatter(time: tmpDouble)
            cell.textLabel?.text = "\(time)"
            return cell
        } else if let tmpInt = Int(tmpInterval) {
            cell.textLabel?.text = "Повторов: \(tmpInt)"
            return cell
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tmpRoundsTrainQQ = roundsTrainQQ else { return "" }
        let tmpNumOfRounds = numOfRounds - tmpRoundsTrainQQ.count + section + 1
        
        return "Раунд \(tmpNumOfRounds)"
    }
}
