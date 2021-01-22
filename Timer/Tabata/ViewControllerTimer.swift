//
//  ViewControllerTimer.swift
//  Timer
//
//  Created by cladendas on 13.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

///Класс таймера
class ViewControllerTimer: UIViewController {
    
    @IBOutlet var optionsBarItem: UIBarButtonItem!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeLabelForRes: UILabel!
    ///Кол-во повторений
    @IBOutlet var numberRep: UILabel!
    ///Кол-во раундов
    @IBOutlet var numberOfRounds: UILabel!
    
    @IBOutlet var start: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var rep: UIButton!

    @IBOutlet var continueLabel: UIButton!
    
    private var notificationCenter = NotificationCenter.default
    
    ///Время старта
    ///- От него расчитываются интервалы
    private var dateStart = Date()
    
    ///Таймер для раунда
    private var timerForRound = Timer()
    private var timerForRoundQ = Timer()
    ///Таймер для отдыха
    private var timerForRes = Timer()
    private var viewControllerRounds = ViewControllerRounds()
    
    ///Время для таймера раунда (максимум 5999.99)
    private var timeForRound: Double = 1.0
    ///Время для таймера отдыха (максимум 5999.99)
    private var timeForRes: Double = 0.9
    ///Переменная для хранения начального значения времени таймера раунда (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    ///Переменная для хранения начального значения времени таймера отдыха (максимум 5999.99)
    private var tmpTimeForRes: Double = 0.0
    ///Какой таймер сейчас работает: true - идёт отсчёт времени для таймера раунда, иначе - для таймера отдыха
    private var switchRoundRes = true
    ///Кол-во раундов
    private var countOfRounds = 3
    ///Переменная для хранения начального значения кол-ва раундов
    private var tmpCountOfRounds = 0
    ///Кол-во выполненных повторений
    private var countRep = 0
    ///Интервал от времени dateStart
    private var timeIntervalFromDateStart: Double = 00.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = true
        continueLabel.isHidden = true
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(
            ofSize: 70, weight: .regular)
        
        timeLabelForRes.font = UIFont.monospacedDigitSystemFont(
        ofSize: 70, weight: .regular)
        
        tmpTimeForRound = timeForRound
        tmpTimeForRes = timeForRes
        tmpCountOfRounds = countOfRounds
        
        timeLabel.text = TimeFormatter.formatter(time: timeForRound)
        timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
        numberRep.text = String(countRep)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(getNotification), name: .training, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    func getNotification(notification: Notification) {
        guard let item = notification.userInfo as? [String: [String]] else { return }
        
        if let train = item["tabata"] {
            self.countOfRounds = Int(Double(train[0])!)
            self.numberOfRounds.text = "Раундов \(self.countOfRounds)/\(self.countOfRounds)"
            self.tmpCountOfRounds = self.countOfRounds
            
            self.timeForRound = Double(train[1]) ?? 0.0
            self.tmpTimeForRound = timeForRound
            self.timeLabel.text = TimeFormatter.formatter(time: timeForRound)
            
            self.timeForRes = Double(train[2]) ?? 0.0
            self.tmpTimeForRes = timeForRes
            self.timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
        }
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = false
        optionsBarItem.isEnabled = false
        
        switchRoundRes = true
        dateStart = Date()
        
        timerForRound = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        
        timeIntervalFromDateStart = dateStart.timeIntervalSinceNow
        
        timerForRound.invalidate()
        timerForRes.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        continueLabel.isHidden = true
        
        dateStart = Date()
        dateStart += timeIntervalFromDateStart
        
        if switchRoundRes {
            timerForRound = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)

            timeIntervalFromDateStart = 00.00
        } else {
             timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRes), userInfo: nil, repeats: true)
            
            timeIntervalFromDateStart = 00.00
        }
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        timerForRound.invalidate()
        timerForRes.invalidate()
        
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        numberRep.isHidden = true
        rep.isHidden = true
        continueLabel.isHidden = true
        optionsBarItem.isEnabled = true
        switchRoundRes = true
        
        timeForRound = tmpTimeForRound
        timeForRes = tmpTimeForRes
        countOfRounds = tmpCountOfRounds
        timeLabel.text = TimeFormatter.formatterQ(interval: timeForRound)
        timeLabelForRes.text = TimeFormatter.formatterQ(interval: timeForRes)
        numberOfRounds.text = "Раундов \(countOfRounds)/\(countOfRounds)"
    }
    
    ///Подсчёт повторений. Здесь погрешность в том, если будут выполняться какие-то быстрые двжения, требующие подсчёта (прыжки на скакалке, выбросы грифа, полуприседы). Обработка нажатия на кнопку не успевает. Подсчёт работает и во время отдыха
    @IBAction func repAction(_ sender: UIButton) {
        countRep += 1
        numberRep.text = "\(countRep)"
        
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
    
    private func startRes() {
        dateStart = Date()
        if countOfRounds > 0 {
            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRes), userInfo: nil, repeats: true)
        } else {
            stopAction(stop)
        }
    }
    
    @objc
    private func timerUpdateForRound() {
        if -dateStart.timeIntervalSinceNow >= timeForRound {
            timerForRound.invalidate()
            //чтобы таймер стратовал с заданного значения
            timeForRound = tmpTimeForRound
            countOfRounds -= 1
            numberOfRounds.text = "Раундов \(countOfRounds)/\(tmpCountOfRounds)"
            timeLabel.text = TimeFormatter.formatterQ(interval: timeForRound)
            startRes()
            switchRoundRes = false
        } else {
            timeLabel.text = TimeFormatter.formatterQ(interval: timeForRound + dateStart.timeIntervalSinceNow)
        }
    }
    
    @objc
    private func timerUpdateForRes() {
        if -dateStart.timeIntervalSinceNow >= timeForRes {
            timerForRes.invalidate()
            //чтобы таймер стартовал с заданного значения
            timeForRes = tmpTimeForRes
            timeLabelForRes.text = TimeFormatter.formatterQ(interval: timeForRes)
            startAction(start)
            switchRoundRes = true
        } else {
            timeLabelForRes.text = TimeFormatter.formatterQ(interval: timeForRes + dateStart.timeIntervalSinceNow)
        }
    }
}
