//
//  ViewControllerTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerTrain: UIViewController {
    
    @IBOutlet var timer: UILabel!
    @IBOutlet var numberOfRep: UILabel!
    
    @IBOutlet var stop: UIButton!
    @IBOutlet var pause: UIButton!
    @IBOutlet var start: UIButton!
    @IBOutlet var continueLabel: UIButton!
    @IBOutlet var rep: UIButton!
    @IBOutlet var options: UIButton!
    
    @IBOutlet var tableOfTrain: UITableView!
    
    var roundsTrain: [Double] = []
    var vcOptionTrain = ViewControllerOptionsTrain()
    
    var timerForTrain = Timer()
    ///Время для таймера раунда (максимум 5999.99)
    private var timeForRound: Double = 1.0
    ///Переменная для хранения начального значения времени таймера раунда (максимум 5999.99)
    private var tmpTimeForRound: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfRep.isHidden = true
        pause.isHidden = true
        rep.isHidden = true
        stop.isHidden = true
        continueLabel.isHidden = true
        
        vcOptionTrain.clouserRounds = { [unowned self] rounds in
            self.roundsTrain = rounds
        }
        
        tableOfTrain.delegate = self
        tableOfTrain.dataSource = self
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if case let controller as ViewControllerOptionsTrain = segue.destination, segue.identifier == "OptionsTimer" {
        }
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        pause.isHidden = false
        rep.isHidden = false
        start.isHidden = true
        stop.isHidden = true
        options.isHidden = true
        numberOfRep.isHidden = false
        
        timerForTrain = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerUpdateForRound), userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerUpdateForRound() {
        timeForRound -= 00.01
//        if timeForRound <= 0.0 && countOfRounds > 0 {
//            timerForRound.invalidate()
//            //чтобы таймер стратовал с заданного значения
//            timeForRound = tmpTimeForRound
//            countOfRounds -= 1
//            
//            numberOfRounds.text = "Раундов \(countOfRounds)/\(tmpCountOfRounds)"
//            
//            startRes()
//        } else {
//            timer.text = TimeFormatter.formatter(time: timeForRound)
//        }
    }

}

extension ViewControllerTrain: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsTrain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrain", for: indexPath)
        
        let time = TimeFormatter.formatter(time: roundsTrain[indexPath.row])
        
        cell.textLabel?.text = time

        return cell
    }
    
    
}
