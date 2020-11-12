//
//  ViewController.swift
//  Timer
//
//  Created by cladendas on 12.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var start: UIButton!
    @IBOutlet var round: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var stop: UIButton!
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        round.isHidden = false
    }
    @IBAction func roundAction(_ sender: UIButton) {
    }
    @IBAction func pauseAction(_ sender: UIButton) {
    }
    @IBAction func stopAction(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pause.isHidden = true
        round.isHidden = true
    }

}

