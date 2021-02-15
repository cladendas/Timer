//
//  CellStopwatch.swift
//  Timer
//
//  Created by cladendas on 17.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class CellStopwatch: UITableViewCell {

    @IBOutlet var round: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var best: UILabel!
    
    func initCell (round: String, time: String, isTheBest: String) {
        self.round.text = "\(round) круг"
        self.time.text = time
        
        if isTheBest == "Худший" {
            self.best.textColor = .red
            self.best.text = isTheBest
        } else {
            self.best.textColor = .green
            self.best.text = isTheBest
        }
    }
}
