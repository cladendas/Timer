//
//  ViewController.swift
//  Timer
//
//  Created by cladendas on 12.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var start: UIButton!
    @IBOutlet var round: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    
    var timer = Timer()
    
    var tmpTimeInterval: Float = 00.00
    
    var rounds = ""
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        round.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @IBAction func roundAction(_ sender: UIButton) {
        rounds = String(format: "00:%.2f", tmpTimeInterval)
        print("!!!!!", rounds)
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        round.isHidden = true
        pause.isHidden = true
        stop.isHidden = false
        start.isHidden = false
        
        timer.invalidate()
        
        timeLabel.text = String(format: "00:%.2f", tmpTimeInterval)
    }

    @IBAction func stopAction(_ sender: Any) {
        pause.isHidden = true
        start.isHidden = false
        
        timer.invalidate()
        tmpTimeInterval = 00.00
        
        timeLabel.text = "00:00,00"
    }
    
    @objc
    func timerUpdate() {
        
        tmpTimeInterval += 00.01
      
//        print(String(format: "00:%.2f", tmpTimeInterval))
        timeLabel.text = String(format: "00:%.2f", tmpTimeInterval)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        round.isHidden = true
    }
}

