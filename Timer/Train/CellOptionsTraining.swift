//
//  CellOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class CellOptionsTraining: UITableViewCell {

    ///Временной интервал
    @IBOutlet var time: UILabel!
    ///Интервал повторений
    @IBOutlet var rep: UILabel!
    ///Выбор между временным интервалом и интервалом повторений
    @IBOutlet var segmentControlTrain: UISegmentedControl!
    ///Установка значения для выбранного интервала
    @IBOutlet var stepperTime: UIStepper!
    
    ///Начальное значение лейбла для временного интервала
    private let startTime = "Интервал 00:05:00"
    ///Начальное значение для лейбла с кол-ом повторений
    private let startRep = "Повторов: 1"
    ///Как будет начинаться строка с временным интервалом
    private let leadingTimeLabel = "Интервал "
    ///Как будет начинаться строка с кол-ом повторений
    private let leadingRepLabel = "Повторов: "
    ///Колбэк для передачи данных из ячейки
    var clouserStepperValue: ((Any) -> Void)?
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.rep.isHidden = true
            self.time.isHidden = false
            self.time.text = startTime
            self.stepperTime.value = 1.0
            
            clouserStepperValue?(stepperTime.value * 5)
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            self.time.isHidden = true
            self.rep.isHidden = false
            self.rep.text = startRep
            self.stepperTime.value = 1.0
            
            let intValue = Int(stepperTime.value)
            
            clouserStepperValue?(intValue)
        }
    }
    
    @IBAction func stepperTimeAction(_ sender: UIStepper) {
        
        if segmentControlTrain.selectedSegmentIndex == 0 {
            let tmpValue = TimeFormatter.formatter(time: sender.value * 5)
            let tmpLabelText = leadingTimeLabel + tmpValue
            time.text = tmpLabelText
            
            clouserStepperValue?(sender.value * 5)
        }
        
        if segmentControlTrain.selectedSegmentIndex == 1 {
            let tmpLabelText = leadingRepLabel + "\(Int(sender.value))"
            rep.text = tmpLabelText
            
            let intValue = Int(sender.value)
            
            clouserStepperValue?(intValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rep.isHidden = true
    }
}
