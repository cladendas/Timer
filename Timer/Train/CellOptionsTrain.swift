//
//  CellOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class CellOptionsTrain: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var stepperTime: UIStepper!
    
    var clouserStepperTime: ((Double) -> Void)?
    
    func initCell(time: String) {
//        clouserStepperTime?(13.0)
        self.time.text = time
    }
    
    @IBAction func stepperTimeAction(_ sender: UIStepper) {
        let tmpValue = TimeFormatter.formatter(time: sender.value)
//        clouserNumOfRounds?(tmpValue)
        time.text = "Интервал \(tmpValue)"
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
