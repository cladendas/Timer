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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        pause.isHidden = true
        rep.isHidden = true
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
            
//            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }
        
        
        @IBAction func pauseAction(_ sender: UIButton) {
            pause.isHidden = true
            rep.isHidden = true
            stop.isHidden = false
            start.isHidden = false
            
//            timer.invalidate()
            
//            timeLabel.text = String(format: "00:%.2f", tmpTimeInterval)
        }

        @IBAction func stopAction(_ sender: Any) {
            pause.isHidden = true
            start.isHidden = false
            
//            timer.invalidate()
//            tmpTimeInterval = 00.00
            
            timeLabel.text = "00:00,00"
        }
    
    @IBAction func repAction(_ sender: UIButton) {
        
    }
    
        
        @objc
        func timerUpdate() {
            
//            tmpTimeInterval += 00.01
          
    //        print(String(format: "00:%.2f", tmpTimeInterval))
//            timeLabel.text = String(format: "00:%.2f", tmpTimeInterval)
        }
}
