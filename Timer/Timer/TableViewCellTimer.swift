//
//  TableViewCellTimer.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class TableViewCellTimer: UITableViewCell {
    
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var timeForRound: UILabel!
    @IBOutlet var timeForRes: UILabel!
    
    ///Кол-во раундов
    var clouserNumOfRounds: ((Int) -> Void)?
    ///Время раунда
    var clouserTimeForRound: ((Double) -> Void)?
    ///Время отдыха
    var clouserTimeForRes: ((Double) -> Void)?
    
    @IBAction func stepperForNumForRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        clouserNumOfRounds?(tmpValue)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
    }
    
    @IBAction func stepperForTimeForRoundsAction(_ sender: UIStepper) {
        let tmpValue = TimeFormatter.formatter(time: sender.value)
        clouserTimeForRound?(sender.value)
        timeForRound.text = "Время раунда: \(tmpValue)"
    }
    
    @IBAction func stepperForTimeForResAction(_ sender: UIStepper) {
        let tmpValue = TimeFormatter.formatter(time: sender.value)
        clouserTimeForRes?(sender.value)
        timeForRes.text = "Время отдыха: \(tmpValue)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
