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
    
    
    var timer = Timer()
    
    var tmpTimeInterval: Float = 15.94
    var tmpStartTimeInterval: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        
        tmpStartTimeInterval = tmpTimeInterval
        timeLabel.text = qq(tmp: tmpTimeInterval)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        rounds.isHidden = true
            
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
        
        timer.invalidate()
        
        tmpTimeInterval = tmpStartTimeInterval
        timeLabel.text = qq(tmp: tmpStartTimeInterval)
    }
    
    @IBAction func repAction(_ sender: UIButton) {
        
    }
    
        
    @objc
    func timerUpdate() {
        
        tmpTimeInterval -= 00.01
        
        if tmpTimeInterval <= 0.0 {
            timer.invalidate()
            timeLabel.text = qq(tmp: tmpStartTimeInterval)
            
            pause.isHidden = true
            start.isHidden = false
            rounds.isHidden = false
            
            stopAction(self)
        }
        
        timeLabel.text = qq(tmp: tmpTimeInterval)
    }
    
    func qq(tmp: Float) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        let ss = String(format: "%02d", Int(tmp / 60))
        let qq = String(format: "%02d", Int(tmp.truncatingRemainder(dividingBy: 60)))

        let b = Int(tmp)
        let gh = tmp - Float(b)
        
        print("\(ss):\(qq):\(formatter.string(from: gh * 100 as NSNumber) ?? "n/a"), \(qq) ")
        
        return "\(ss):\(qq):\(formatter.string(from: gh * 100 as NSNumber) ?? "n/a")"
    }
}
