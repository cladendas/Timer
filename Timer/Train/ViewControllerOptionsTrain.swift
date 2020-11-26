//
//  ViewControllerOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

class ViewControllerOptionsTrain: UIViewController {
    
    @IBOutlet var tableOfTrain: UITableView!
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var stepperNumOfRounds: UIStepper!
    
    private var notificationCenter = NotificationCenter.default
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : Any]()

    ///Тренировка представлена в виде кол-ва раундов (здесь элемент под индексом 0) и временными интервалами (здесь элемент массива, который под индексом 1)
    var roundsQQ: [[Any]] = [[1], [5.0, 4, 10.0]]

    var stepperRoundValue = 5.0

    ///Колбэк для данных в таблице настройки тренировки
//    var clouserTableTrain: (([[Any]]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self
        
//        if let data = SaverLoader.load(for: "round") {
//            roundsQQ = data as! [[Any]]
//            clouserQ?(roundsQQ)
//        }
        
//        clouserTableTrain?(roundsQQ)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let train = ["rounds" : roundsQQ[0][0], "intervals" : roundsQQ[1]]
        notificationCenter.post(name: .train, object: self, userInfo: train)
        
        notificationCenter.removeObserver(self)
    }
    
    @IBAction func addTimeAction(_ sender: Any) {
        roundsQQ[1].append(stepperRoundValue)
//        clouserTableTrain?(roundsQQ)
        tableOfTrain.reloadData()
//        SaverLoader.save(value: roundsQQ, for: "round")
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        roundsQQ[0] = [Int(sender.value)]
//        clouserTableTrain?(roundsQQ)
        tableOfTrain.reloadData()
//        SaverLoader.save(value: roundsQQ, for: "round")
        print(roundsQQ[1])
    }

}

extension ViewControllerOptionsTrain: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roundsQQ[1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTrain

        notificationCenter.addObserver(self, selector: #selector(getCellValue), name: .interval, object: nil)
        
        if let time = intervalQ["time"] {
            roundsQQ[1][indexPath.row] = time
//            notificationCenter.removeObserver(self)
        } else if let exercise = intervalQ["exercise"] {
            roundsQQ[1][indexPath.row] = exercise
//            notificationCenter.removeObserver(self)
        }
        
        return cell
    }
    
    @objc
    func getCellValue(notification: Notification) {
        guard let item = notification.userInfo else { return }

        if let time = item["time"] {
            intervalQ = ["time" : time]
        } else if let exercise = item["exercise"] {
            intervalQ =  ["exercise" : exercise as! Int]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            roundsQQ[1].remove(at: indexPath.row)
//            clouserTableTrain?(roundsQQ)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableOfTrain.reloadData()
//            SaverLoader.save(value: roundsQQ, for: "round")
        }
    }
}
