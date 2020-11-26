//
//  CellOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let interval = NSNotification.Name.init("interval")
    static let train = NSNotification.Name.init("train")
}

class CellOptionsTrain: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var rep: UILabel!
    @IBOutlet var segmentControlTrain: UISegmentedControl!
    @IBOutlet var stepperTime: UIStepper!
    
    ///Начальное значение лейбла для временного интервала
    private let startTime = "Интервал 00:05:00"
    ///Начальное значение для лейбла с кол-ом повторений
    private let startRep = "Повторов: 1"
    ///Как будет начинаться строка с временным интервалом
    private let leadingTimeLabel = "Интервал "
    ///Как будет начинаться строка с кол-ом повторений
    private let leadingRepLabel = "Повторов: "
    
    private var notificationCenter = NotificationCenter.default
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.rep.isHidden = true
            self.time.isHidden = false
            self.time.text = startTime
            self.stepperTime.value = 1.0

            let time = ["time" : stepperTime.value * 5]
            notificationCenter.post(name: .interval, object: self, userInfo: time)
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            self.time.isHidden = true
            self.rep.isHidden = false
            self.rep.text = startRep
            self.stepperTime.value = 1.0

            let exercise = ["exercise" : Int(stepperTime.value)]
            notificationCenter.post(name: .interval, object: self, userInfo: exercise)
        }
    }
    
    @IBAction func stepperTimeAction(_ sender: UIStepper) {
        
        if segmentControlTrain.selectedSegmentIndex == 0 {
            let tmpValue = TimeFormatter.formatter(time: sender.value * 5)
            let tmpLabelText = leadingTimeLabel + tmpValue
            time.text = tmpLabelText
            
            let time = ["time" : tmpValue]
            notificationCenter.post(name: .interval, object: self, userInfo: time)
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            let tmpLabelText = leadingRepLabel + "\(Int(sender.value))"
            rep.text = tmpLabelText
            
            let exercise = ["exercise" : Int(sender.value)]
            notificationCenter.post(name: .interval, object: self, userInfo: exercise)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rep.isHidden = true
    }
}
