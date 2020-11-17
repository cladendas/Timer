//
//  ViewControllerTimer.swift
//  Timer
//
//  Created by cladendas on 13.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerTimer: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeLabelForRes: UILabel!
    @IBOutlet var start: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var rep: UIButton!
    @IBOutlet var rounds: UIButton!
    @IBOutlet var numberRep: UILabel!
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var continueLabel: UIButton!
    
    ///Таймер для раунда
    private var timerForRounds = Timer()
    ///Таймер для отдыха
    private var timerForRes = Timer()
    private var viewControllerRounds = ViewControllerRounds()
    
    ///Время для таймера раунда (максимум 5999.99)
    private var timeForRound: Float = 1.0
    ///Время для таймера отдыха (максимум 5999.99)
    private var timeForRes: Float = 0.9
    ///Переменная для хранения начального значения времени таймера раунда (максимум 5999.99)
    private var tmptimeForRound: Float = 0.0
    ///Переменная для хранения начального значения времени таймера отдыха (максимум 5999.99)
    private var tmpTimeForRes: Float = 0.0
    ///Кол-во раундов
    private var countOfRounds = 3
    ///Переменная для хранения начального значения кол-ва раундов
    private var tmpCountOfRounds = 0
    ///Кол-во выполненных повторений
    private var countRep = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = true
        continueLabel.isHidden = true
        
        tmptimeForRound = timeForRound
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
        
        timerForRounds = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRounds), userInfo: nil, repeats: true)
    }
        
        
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        start.isHidden = false
        rounds.isHidden = false
        continueLabel.isHidden = false

        timerForRounds.invalidate()
        timerForRes.invalidate()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        stop.isHidden = true
        start.isHidden = true
        rounds.isHidden = true
        continueLabel.isHidden = true
        
//        if !timerForRounds.isValid {
//            timerForRounds = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRounds), userInfo: nil, repeats: true)
//        }
//        
//        if !timerForRes.isValid {
//            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRest), userInfo: nil, repeats: true)
//        }
    }
    

    @IBAction func stopAction(_ sender: UIButton) {
        timerForRounds.invalidate()
        timerForRes.invalidate()
        
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rounds.isHidden = false
        numberRep.isHidden = true
        rep.isHidden = true
        continueLabel.isHidden = true
        
        timeForRound = tmptimeForRound
        timeForRes = tmpTimeForRes
        countOfRounds = tmpCountOfRounds
        timeLabel.text = TimeFormatter.formatter(time: timeForRound)
        timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
        
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
        
    @objc
    private func timerUpdateForRounds() {
        timeForRound -= 00.01
        if timeForRound <= 0.0 && countOfRounds > 0 {
            timerForRounds.invalidate()
            timeForRound = tmptimeForRound
            countOfRounds -= 1
            startRes()
        } else {
            timeLabel.text = TimeFormatter.formatter(time: timeForRound)
        }
    }
    
    private func startRes() {
        if countOfRounds > 0 {
            timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRest), userInfo: nil, repeats: true)
        } else {
            stopAction(stop)
        }
    }
    
    @objc
    private func timerUpdateForRest() {
        timeForRes -= 00.01
        if timeForRes <= 0.0 {
            timerForRes.invalidate()
            timeForRes = tmpTimeForRes
            startAction(start)
        } else {
            timeLabelForRes.text = TimeFormatter.formatter(time: timeForRes)
        }
    }
}
