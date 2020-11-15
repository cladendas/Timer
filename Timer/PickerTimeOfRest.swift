//
//  PickerTimeOfRest.swift
//  Timer
//
//  Created by cladendas on 14.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class PickerTimeOfRest: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerDataNumOfRoundsM: [String] = [String]()
    var pickerDataNumOfRoundsS: [String] = [String]()
    
    var dd: String = "1111"
    
    var aa: ((String) -> ())?
    
    var notif = NotificationCenter.default
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        for i in 0...59 {
            pickerDataNumOfRoundsM.append(String(i))
        }
        
        for i in 0...59 {
            pickerDataNumOfRoundsS.append(String(i))
        }

        delegate = self
        dataSource = self
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return pickerDataNumOfRoundsM.count
        } else {
            return pickerDataNumOfRoundsS.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return pickerDataNumOfRoundsM[row]
        } else {
            return pickerDataNumOfRoundsS[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            dd = "Вермя отдыха: \(pickerDataNumOfRoundsM[row]):\(pickerDataNumOfRoundsS[0])"
            print(dd)
            aa?(dd)
        } else {
            dd = "Вермя отдыха: \(pickerDataNumOfRoundsM[0]):\(pickerDataNumOfRoundsS[row])"
            print(dd)
            aa?(dd)
        }
    }
}
