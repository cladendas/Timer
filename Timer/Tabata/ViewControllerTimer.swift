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
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeLabelForRes: UILabel!
    @IBOutlet var numberRep: UILabel!
    @IBOutlet var numberOfRounds: UILabel!
    
    @IBOutlet var start: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var rep: UIButton!
    @IBOutlet var rounds: UIButton!

    @IBOutlet var continueLabel: UIButton!
    
    ///Таймер для раунда
    private var timerForRound = Timer()
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
    ///Кол-во раундов
    private var countOfRounds = 3
    ///Переменная для хранения начального значения кол-ва раундов
    private var tmpCountOfRounds = 0
    ///Кол-во выполненных повторений
    private var countRep = 0
    ///Текущее время раунда
    var currentTimeOfRound: Double = 00.00
    ///Текущее время отдыха
    var currentTimeOfRes: Double = 00.00
    
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
    
    //Здесь захватывается numberOfRounds, чтобы выставить в него кол-во раундов
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let controller as ViewControllerRounds = segue.destination, segue.identifier == "Rounds" {

            controller.clouserNumOfRounds = { [unowned self] num in
                self.numberOfRounds.text = "Раундов \(String(num))/\(String(num))"
                self.countOfRounds = num
                self.tmpCountOfRounds = num
            }

            controller.clouserTimeForRound = { [unowned self] time in
                self.timeLabel.text = TimeFormatter.formatter(time: time)
                self.timeForRound = time
                self.tmpTimeForRound = time
            }

            controller.clouserTimeForRes = { [unowned self] time in
                self.timeLabelForRes.text = TimeFormatter.formatter(time: time)
                self.timeForRes = time
                self.tmpTimeForRes = time
            }
        }
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        rounds.isHidden = true
        numberRep.isHidden = false
        
        timerForRound = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
        
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        continueLabel.isHidden = false
        
        currentTimeOfRound = timeForRound
        currentTimeOfRes = timeForRes
        
        timerForRound.invalidate()
        timerForRes.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        continueLabel.isHidden = true

        if timeForRound != tmpTimeForRound {
            timeForRound = currentTimeOfRound

            timerForRound = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
            
            currentTimeOfRound = 00.00
        }
        
        if timeForRes != tmpTimeForRes {
            timeForRes = currentTimeOfRes

            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRes), userInfo: nil, repeats: true)
            
            currentTimeOfRes = 00.00
        }
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        timerForRound.invalidate()
        timerForRes.invalidate()
        
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rounds.isHidden = false
        numberRep.isHidden = true
        rep.isHidden = true
        continueLabel.isHidden = true
        
        timeForRound = tmpTimeForRound
        timeForRes = tmpTimeForRes
        countOfRounds = tmpCountOfRounds
        timeLabel.text = TimeFormatter.formatter(time: timeForRound)
        timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
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
        if countOfRounds > 0 {
            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRes), userInfo: nil, repeats: true)
        } else {
            stopAction(stop)
        }
    }
    
    @objc
    private func timerUpdateForRound() {
        timeForRound -= 00.01
        if timeForRound <= 0.0 && countOfRounds > 0 {
            timerForRound.invalidate()
            //чтобы таймер стратовал с заданного значения
            timeForRound = tmpTimeForRound
            countOfRounds -= 1
            
            numberOfRounds.text = "Раундов \(countOfRounds)/\(tmpCountOfRounds)"
            
            startRes()
        } else {
            timeLabel.text = TimeFormatter.formatter(time: timeForRound)
        }
    }
    
    @objc
    private func timerUpdateForRes() {
        timeForRes -= 00.01
        if timeForRes <= 0.0 {
            timerForRes.invalidate()
            //чтобы таймер стартовал с заданного значения
            timeForRes = tmpTimeForRes
            startAction(start)
        } else {
            timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
        }
    }
}
