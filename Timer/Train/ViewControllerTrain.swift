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
    
    @IBOutlet var tableOfTraining: UITableView!
    
    private var notificationCenter = NotificationCenter.default
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : String]()
    
    var roundsTraining: [Double] = [2.0, 24.0, 13]
    
    var dateTraining = Date()
    var dateStart = Date()
    ///Интервалы
    var roundsTrainingQ = [[Double]]()
    var roundsQ = [[3.0], [4.0, 5.0, 6.0]]
    ///Хранит в чистом виде данные из ViewControllerOptionsTrain: кол-во раундов, повторения и/или временные интервалы
    var roundsQQ = [[Any]]()
    ///Тренировка: временные интервалы и/или кол-во повторений
    var roundsTrainingQQ: [[String]]?
    
    var tmpRoundsTrain: [Double] = []
    
    var numOfRounds = 0
    var countNumOfTrains = 0
    var countRep = 0
    
    ///Таймер для всей тренировки
    var timerForTraining = Timer()
    ///Хранит время, ушедшее на тренировку
    var timeForTraining: Double = 0.0
    ///Хранит время тренировки в случае паузы
    var tmpTimeForTraining: Double = 0.0
    ///Таймер для интервалов
    var timerForInterval = Timer()
    ///Хранит временной интервал (максимум 5999.99)
    private var timeForRound: Double = 0.0
    ///Хранит начальное значение временного интервала из переменной  timeForRound (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    ///Хранит текущее значение временного интервала
    var tmpTime: Double = 00.00
    ///Текущее время раунда
    var currentTimeOfRound: Double = 00.00
    
    var viewControllerOptionsTrain = ViewControllerOptionsTraining()
    
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
        
        tableOfTraining.delegate = self
        tableOfTraining.dataSource = self
        
        tmpRoundsTrain = roundsTraining
        countNumOfTrains = roundsTraining.count
        
        if let data = SaverLoader.load(for: "train") {
            self.roundsTrainingQQ = data
            self.numOfRounds = data.count
            tableOfTraining.reloadData()
        }
        
        changeFontAndValueForTimeLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(getNotification), name: .training, object: nil)
    }
    
    ///Поиск в тренировке временного интервала
    ///- Возвращается первое попавшееся значение
    private func findTime() -> Double {
        
        guard let tmpRoundsTrainQQ = roundsTrainingQQ else { return 0.0 }
        
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
    private func checkTypeInterval() -> [String: String]? {
        
        guard let tmp = roundsTrainingQQ, let first = tmp[0].first  else { return nil }
        
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
            self.roundsTrainingQQ = Array(repeating: train[1], count: self.numOfRounds)
        }
        self.tableOfTraining.reloadData()
        changeFontAndValueForTimeLabel()
        
        SaverLoader.save(value: self.roundsTrainingQQ!, for: "train")
    }
    
    var sw = true
    
    @IBAction func startAction(_ sender: UIButton) {
        if sw {
            dateTraining = Date()
            
            sw = false
        }
        
        dateStart = Date()
        
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        numberOfRep.isHidden = false
        optionsBarItem.isEnabled = false
        
        timerForTraining = countTimeForTraining()
        
        if let _ = checkTypeInterval()?["time"] {
            pause.isHidden = false
            timerForInterval = timer()
        } else if let _ = checkTypeInterval()?["exercise"] {
            pause.isHidden = true
            nextButton.isHidden = false
        }
    }
    
    ///У лейбла таймера выставит соотвествующее значение, изменит размер шрифта для интервала повторений
    private func changeFontAndValueForTimeLabel() {
        if let time = checkTypeInterval()?["time"] {
            let tmp = Double(time) ?? 0.0
            timeForRound = tmp
            tmpTimeForRound = tmp
            self.time.font = UIFont.monospacedDigitSystemFont(ofSize: 70, weight: .regular)
            self.time.text = TimeFormatter.formatter(time: tmp)
        } else if let exercise = checkTypeInterval()?["exercise"] {
            self.time.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.regular)
            self.time.textAlignment = .justified
            self.time.text = "Повторов: \(exercise)"
        }
    }
    
    ///Указанный интервал повторений выполнен
    @IBAction func nextAction(_ sender: UIButton) {
        
        roundsTrainingQQ?[0].remove(at: 0)
        tableOfTraining.reloadData()
        
        if roundsTrainingQQ?[0].count == 0 {
            roundsTrainingQQ?.remove(at: 0)
            tableOfTraining.reloadData()
        }
        
        if roundsTrainingQQ?.count == 0 {
            stopAction(stop)
            self.time.text = "Допрыгался!"
        } else if let time = checkTypeInterval()?["time"] {
            nextButton.isHidden = true
            pause.isHidden = false
            timeForRound = Double(time) ?? 0.0
            startAction(start)
        } else if let exercise = checkTypeInterval()?["exercise"] {
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
        tmpTimeForTraining = timeForTraining
        
        timerForTraining.invalidate()
        timerForInterval.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        continueLabel.isHidden = true
        
        if timeForRound != tmpTimeForRound {
            timeForRound = currentTimeOfRound

            timerForInterval = timer()

            currentTimeOfRound = 00.00
        }
        
        timeForTraining = tmpTimeForTraining
        timerForTraining = countTimeForTraining()
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        timerForInterval.invalidate()
        timerForTraining.invalidate()

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
        
        alertFinishTraining()
        sw = true
        
        print("stop")
    }
    
    ///Подсчёт повторений. Здесь погрешность в том, если будут выполняться какие-то быстрые двжения, требующие подсчёта (прыжки на скакалке, выбросы грифа, полуприседы). Обработка нажатия на кнопку не успевает. Подсчёт работает и во время отдыха
    @IBAction func repAction(_ sender: UIButton) {
        countRep += 1
        numberOfRep.text = "\(countRep)"
        
        changeViewBackground()
    }
    
    ///Алерт, который появится по окончанию тренировки или после нажатия на "Стоп"
    ///- Отобразит время затраченное на тренировку
    private func alertFinishTraining() {
        let tmpTime = TimeFormatter.formatterQ(interval: -dateTraining.timeIntervalSinceNow)
        
        let alert = UIAlertController(title: "Тренировка окончена", message: "затраченное время \(tmpTime)", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
        if let data = SaverLoader.load(for: "train") {
            self.roundsTrainingQQ = data
            self.numOfRounds = data.count
            tableOfTraining.reloadData()
        }
        
        timeForTraining = 0.0
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
    
    ///Для отсчёта времени интервала
    private func timer() -> Timer {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
    
    ///Для отсчёта времени всей тренировки
    private func countTimeForTraining() -> Timer {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForTraining), userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerUpdateForRound() {
        if -dateStart.timeIntervalSinceNow >= timeForRound {
            timerForInterval.invalidate()

            //Удаление истёкшего интервала
            roundsTrainingQQ?[0].remove(at: 0)
            tableOfTraining.reloadData()

            //Удаление пустого массива
            if roundsTrainingQQ?[0].count == 0 {
                roundsTrainingQQ?.remove(at: 0)
                tableOfTraining.reloadData()
            }

            //Завершени тренировки, если не осталось интервалов
            if roundsTrainingQQ?.count == 0 {
                stopAction(stop)
                self.time.text = "Допрыгался!"
            } else if let time = checkTypeInterval()?["time"] {
                pause.isHidden = false
                nextButton.isHidden = true
                timeForRound = Double(time) ?? 0.0
                startAction(start)
            } else if let exercise = checkTypeInterval()?["exercise"] {
                pause.isHidden = true
                nextButton.isHidden = false
                self.time.text = "Повторов: \(exercise)"
                startAction(start)
            }
        } else {
            time.text = TimeFormatter.formatterQ(interval: timeForRound + dateStart.timeIntervalSinceNow)
        }
    }
    
    @objc
    private func timerUpdateForTraining() {
        timeForTraining += 00.01
    }
}

extension ViewControllerTrain: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let tmpRoundsTrainQQ = roundsTrainingQQ else { return 0 }
        
        return tmpRoundsTrainQQ.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tmpRoundsTrainQQ = roundsTrainingQQ else { return 0 }
        
        return tmpRoundsTrainQQ[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)

        guard let tmpRoundsTrainQQ = roundsTrainingQQ else { return UITableViewCell() }
        
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
        guard let tmpRoundsTrainQQ = roundsTrainingQQ else { return "" }
        let tmpNumOfRounds = numOfRounds - tmpRoundsTrainQQ.count + section + 1
        
        return "Раунд \(tmpNumOfRounds)"
    }
}
