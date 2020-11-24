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
    @IBOutlet var rep: UILabel!
    @IBOutlet var segmentControlTrain: UISegmentedControl!
    @IBOutlet var stepperTime: UIStepper!
    
    var clouserStepperTime: ((Double) -> Void)?
    var clouserQ: ((Any) -> Void)?
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.rep.isHidden = true
            self.time.isHidden = false
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            self.time.isHidden = true
            self.rep.isHidden = false
        }
    }
    @IBAction func stepperTimeAction(_ sender: UIStepper) {
        
        if segmentControlTrain.selectedSegmentIndex == 0 {
            clouserStepperTime?(sender.value)
            clouserQ?(sender.value * 5)
            let tmpValue = TimeFormatter.formatter(time: sender.value * 5)
            time.text = "Интервал \(tmpValue)"
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            clouserQ?(Int(sender.value))
            rep.text = "Повторов: \(Int(sender.value))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rep.isHidden = true
    }
    
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
