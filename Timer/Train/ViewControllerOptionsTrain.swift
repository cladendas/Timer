//
//  ViewControllerOptionsTrain.swift
//  Timer
//
//  Created by cladendas on 20.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let interval = NSNotification.Name.init("interval")
    static let train = NSNotification.Name.init("train")
    static let tmp = NSNotification.Name.init("tmp")
}

class ViewControllerOptionsTrain: UIViewController {
    
    @IBOutlet var tableOfTrain: UITableView!
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var stepperNumOfRounds: UIStepper!
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : Any]()

    ///Тренировка представлена в виде кол-ва раундов (здесь элемент под индексом 0) и  интервалами повторений или времени (здесь элемент массива, который под индексом 1)
    /// [[2], [20, 5.0, 2.0, 20]]
    var train: [[String]] = [["1"], ["1", "5.0"]]
    ///Колбэк для передачи данных о текущей тренировке
    var clouserTableTrain: (([[Any]]) -> Void)?
    
    ///Значение для нового интервала. При добавлении нового интервала он всегда будет временным и с указанным значением
    private var newInterval = "5.0"
    
    private var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTrain.delegate = self
        self.tableOfTrain.dataSource = self
        
        if let data = SaverLoader.load(for: "trainOptions") {
            self.train = data

            tableOfTrain.reloadData()

            numberOfRounds.text = "Кол-во раундов: \(self.train[0][0])"
            stepperNumOfRounds.value = Double(self.train[0][0]) ?? 0.0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let tmpTrain = ["train" : self.train]
        notificationCenter.post(name: .train, object: self, userInfo: tmpTrain)
        
        clouserTableTrain?(train)
    }
    
    @IBAction func addTimeAction(_ sender: Any) {

        if train.indices.contains(1) {
            train[1].append(newInterval)
        } else if train.indices.contains(0) {
            train.append([newInterval])
        } else {
            train.append(["1"])
            train.append([newInterval])
        }
        
        tableOfTrain.reloadData()
        let train = ["train" : self.train]
        notificationCenter.post(name: .train, object: self, userInfo: train)
        
        SaverLoader.save(value: self.train, for: "trainOptions")
        print("Сохранение при добавлении интервала", self.train)
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        
        if train.indices.contains(0) {
            train[0][0] = String(tmpValue)
        } else {
            train.append([String(tmpValue)])
            train.append([newInterval])
        }
        
        let notifTrain = ["train" : self.train]
        notificationCenter.post(name: .train, object: self, userInfo: notifTrain)
        
        SaverLoader.save(value: self.train, for: "trainOptions")
        print("Сохранение при изменении кол-ва раундов", self.train)
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
        
        if self.train[1][indexPath.row].contains("."), let tmpDouble = Double(self.train[1][indexPath.row]) {
            cell.time.isHidden = false
            cell.rep.isHidden = true
            cell.segmentControlTrain.selectedSegmentIndex = 0
            cell.stepperTime.value = tmpDouble
            cell.time.text = "Интервал \(TimeFormatter.formatter(time: tmpDouble))"
            
            cell.clouserStepperValue = { item in
            
                self.train[1][indexPath.row] = "\(item)"
                self.clouserTableTrain?(self.train)
                
                let train = ["train" : self.train]
                self.notificationCenter.post(name: .train, object: self, userInfo: train)
                SaverLoader.save(value: self.train, for: "trainOptions")
            }
            
            return cell
            
        } else if let tmpInt = Int(self.train[1][indexPath.row]) {
            cell.time.isHidden = true
            cell.rep.isHidden = false
            cell.segmentControlTrain.selectedSegmentIndex = 1
            cell.stepperTime.value = Double(tmpInt)
            cell.rep.text = "Повторов: \(tmpInt)"
            
            cell.clouserStepperValue = { item in
            
                self.train[1][indexPath.row] = "\(item)"
                self.clouserTableTrain?(self.train)
                
                let train = ["train" : self.train]
                self.notificationCenter.post(name: .train, object: self, userInfo: train)
                SaverLoader.save(value: self.train, for: "trainOptions")
            }
            
//            let train = ["train" : self.train]
//            self.notificationCenter.post(name: .train, object: self, userInfo: train)
//            SaverLoader.save(value: self.train, for: "trainOptions")
            
            return cell
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
            
            let train = ["train" : self.train]
            self.notificationCenter.post(name: .train, object: self, userInfo: train)
            
            tableOfTrain.reloadData()

            SaverLoader.save(value: self.train, for: "trainOptions")
        }
    }
}
