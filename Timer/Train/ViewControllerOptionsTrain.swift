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
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : Any]()

    ///Тренировка представлена в виде кол-ва раундов (здесь элемент под индексом 0) и временными интервалами (здесь элемент массива, который под индексом 1)
    var train = [[Any]]()
    ///Колбэк для передачи данных о текущей тренировке
    var clouserTableTrain: (([[Any]]) -> Void)?
    
    ///Значение для нового интервала. При добавлении нового интервала он всегда будет временным и с указанным значением
    private var newInterval = 5.0
    
    private var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self
        
//        if let data = SaverLoader.load(for: "round") {
//            roundsQQ = data as! [[Any]]
//            clouserQ?(roundsQQ)
//        }
        
        clouserTableTrain?(train)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clouserTableTrain?(train)
        print(train)
    }
    
    @IBAction func addTimeAction(_ sender: Any) {

        if train.indices.contains(1) {
            train[1].append(newInterval)
            print("1", train)
        } else if train.indices.contains(0) {
            train.append([newInterval])
            print("2", train)
        } else {
            train.append([1])
            train.append([newInterval])
            print("3", train)
        }
        
        clouserTableTrain?(train)
        tableOfTrain.reloadData()
//        SaverLoader.save(value: roundsQQ, for: "round")
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        
        if train.indices.contains(0) {
            train[0][0] = Int(sender.value)
            print("4", train)
        } else {
            train.append([Int(sender.value)])
            print("5", train)
        }

        clouserTableTrain?(train)
//        SaverLoader.save(value: roundsQQ, for: "round")
    }
}

extension ViewControllerOptionsTrain: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var tt = 0
        
        if train.indices.contains(1) {
            tt = train[1].count
        }
        
        return tt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTrain
        
        cell.clouserStepperValue = { item in
            self.train[1][indexPath.row] = item
            self.clouserTableTrain?(self.train)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            train[1].remove(at: indexPath.row)
            clouserTableTrain?(train)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableOfTrain.reloadData()
//            SaverLoader.save(value: roundsQQ, for: "round")
        }
    }
}
