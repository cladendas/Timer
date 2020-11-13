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
    
    var tmpTimeInterval: Float = 15.94
    var tmpStartTimeInterval: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        numberRep.isHidden = true
        
//        numberRep.layer.cornerRadius = 50
//        numberRep.clipsToBounds = true
        
        tmpStartTimeInterval = tmpTimeInterval
        timeLabel.text = qq(time: tmpTimeInterval)
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
    
//        timeLabel.text = String(format: "00:%.2f", tmpTimeInterval)
    }

    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        stop.isHidden = true
        start.isHidden = false
        rounds.isHidden = false
        numberRep.isHidden = true
        
        timer.invalidate()
        
        tmpTimeInterval = tmpStartTimeInterval
        timeLabel.text = qq(time: tmpStartTimeInterval)
    }
    
    var countRep = 0
    
    @IBAction func repAction(_ sender: UIButton) {
        countRep += 1
        numberRep.text = "\(countRep)"
        
        changeCyanViewBackground()
    }
    
    private func changeCyanViewBackground() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.duration = 0.3
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        view.layer.add(animation, forKey: "background")
        view.layer.backgroundColor = .none
        
    }
        
    @objc
    func timerUpdate() {
        
        tmpTimeInterval -= 00.01
        
        if tmpTimeInterval <= 0.0 {
            timer.invalidate()
            timeLabel.text = qq(time: tmpStartTimeInterval)
            
            pause.isHidden = true
            start.isHidden = false
            rounds.isHidden = false
            
            stopAction(self)
        }
        
        timeLabel.text = qq(time: tmpTimeInterval)
    }
    
    func qq(time: Float) -> String {
        
        let mm = String(format: "%02d", Int(time / 60))
        let ss = String(format: "%02d", Int(time.truncatingRemainder(dividingBy: 60)))

        let b = Int(time)
        let afterPoint = time - Float(b)
        let mls = String(format: "%02d", Int(afterPoint * 100))
        
        return "\(mm):\(ss):\(mls)"
    }
}
