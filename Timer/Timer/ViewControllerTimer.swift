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
    @IBOutlet var start: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    @IBOutlet var rep: UIButton!
    @IBOutlet var rounds: UIButton!
    @IBOutlet var numberRep: UILabel!
    
    
    var timer = Timer()
    
    ///время для таймера раунда (максимум 5999.99)
    var tmpTimeInterval: Float = 5999.99
    var tmpStartTimeInterval: Float = 0.0
    var countRep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = true
        
        tmpStartTimeInterval = tmpTimeInterval
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        rounds.isHidden = true
        numberRep.isHidden = false
            
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
        
        
    @IBAction func pauseAction(_ sender: UIButton) {
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = false
        start.isHidden = false
        rounds.isHidden = false
        
        timer.invalidate()
    }

    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rounds.isHidden = false
        numberRep.isHidden = true
        rep.isHidden = true
        
        timer.invalidate()
        
        tmpTimeInterval = tmpStartTimeInterval
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
    }
    
    //Здесь погрешность в том, если будут выполняться какие-то быстрые двжения, требующие подсчёта (прыжки на скакалке, выбросы грифа, полуприседы). Обработка нажатия на кнопку не успевает
    @IBAction func repAction(_ sender: UIButton) {
        countRep += 1
        numberRep.text = "\(countRep)"
        
        changeViewBackground()
    }
    
    private func changeViewBackground() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black
        }) { (anim) in
            self.view.backgroundColor = .blue
        }
    }
        
    @objc
    func timerUpdate() {
        
        tmpTimeInterval -= 00.01
        
        if tmpTimeInterval <= 0.0 {
            timer.invalidate()
            timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
            
            stopAction(self)
        }
        timeLabel.text = TimeFormatter.formatter(time: tmpTimeInterval)
    }
}
