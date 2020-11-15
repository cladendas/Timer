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
    
    
    var timerForRounds = Timer()
    var timerForRes = Timer()
    
    ///время для таймера раунда (максимум 5999.99)
    var tmpTimeForRound: Float = 1.1
    var tmpTimeForRes: Float = 1.1
    var tmpStartTimeInterval: Float = 0.0
    var tmpRes: Float = 0.0
    var countOfRounds = 2
    var countRep = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = true
        
        tmpStartTimeInterval = tmpTimeForRound
        tmpRes = tmpTimeForRes
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeForRound)
        timeLabelForRes.text = TimeFormatter.formatter(time: tmpTimeForRes)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        rounds.isHidden = true
        numberRep.isHidden = false
        
        if countOfRounds > 0 {
            timerForRounds = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRounds), userInfo: nil, repeats: true)
        }
    }
        
        
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        start.isHidden = false
        rounds.isHidden = false
        
        timerForRounds.invalidate()
    }

    @IBAction func stopAction(_ sender: UIButton) {
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rounds.isHidden = false
        numberRep.isHidden = true
        rep.isHidden = true
        
        timerForRounds.invalidate()
        
        tmpTimeForRound = tmpStartTimeInterval
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeForRound)
    }
    
    //Здесь погрешность в том, если будут выполняться какие-то быстрые двжения, требующие подсчёта (прыжки на скакалке, выбросы грифа, полуприседы). Обработка нажатия на кнопку не успевает
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
    func timerUpdateForRounds() {
        
        tmpTimeForRound -= 00.01
        
        if tmpTimeForRound <= 0.0 && countOfRounds == 0 {
            timerForRounds.invalidate()
            timeLabel.text = TimeFormatter.formatter(time: tmpTimeForRound)
            stopAction(stop)
        } else if tmpTimeForRound <= 0.0 && countOfRounds > 0 {
            timerForRounds.invalidate()
            tmpTimeForRound = tmpStartTimeInterval
            countOfRounds -= 1
            print("!!! ",countOfRounds)
            startRes()
        }
        
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeForRound)
    }
    
    func startRes() {
        
        if countOfRounds > 0 {
                    timerForRes = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRest), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func timerUpdateForRest() {
        tmpTimeForRes -= 00.01
        
        if tmpTimeForRes <= 0.0 {
            timerForRes.invalidate()
            timeLabelForRes.text = TimeFormatter.formatter(time: tmpTimeForRes)
            startAction(start)
            tmpTimeForRes = tmpRes
        }
        
        timeLabelForRes.text = TimeFormatter.formatter(time: tmpTimeForRes)
    }
}
