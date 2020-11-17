//
//  ViewControllerRounds.swift
//  Timer
//
//  Created by cladendas on 14.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerRounds: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerDataNumOfRounds: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...100 {
            pickerDataNumOfRounds.append(String(i))
        }
        
        self.pickerTimeOfRounds.delegate = self
        self.pickerTimeOfRounds.dataSource = self
    }
    
    var clouserNumOfRounds: ((Int) -> Void)?
    
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var pickerTimeOfRounds: UIPickerView!
    @IBOutlet var pickerTimeOfRest: UILabel!
    
    @IBAction func stepperForNumOfRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        clouserNumOfRounds?(tmpValue)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerDataNumOfRounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataNumOfRounds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfRounds.text = "Раунды: \(pickerDataNumOfRounds[row])"
    }
}
