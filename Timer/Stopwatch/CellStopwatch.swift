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
    
    func initCell (round: String, time: String, best: String) {
        self.round.text = round
        self.time.text = time
        
        if best == "Худший" {
            self.best.textColor = .red
            self.best.text = best
        } else {
            self.best.textColor = .green
            self.best.text = best
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
