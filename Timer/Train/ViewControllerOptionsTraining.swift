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
    static let training = NSNotification.Name.init("train")
    static let tmp = NSNotification.Name.init("tmp")
}

class ViewControllerOptionsTraining: UIViewController {
    
    @IBOutlet var tableOfTraining: UITableView!
    @IBOutlet var numberOfRounds: UILabel!
    @IBOutlet var stepperNumOfRounds: UIStepper!
    
    ///Хранит значения от наблюдателя CellOptionsTrain
    private var intervalQ = [String : Any]()

    ///Тренировка представлена в виде кол-ва раундов (здесь элемент под индексом 0) и  интервалами повторений или времени (здесь элемент массива, который под индексом 1)
    /// [[2], [20, 5.0, 2.0, 20]]
    var training: [[String]] = [["1"], ["1", "5.0"]]
    ///Колбэк для передачи данных о текущей тренировке
    var clouserTableTraining: (([[Any]]) -> Void)?
    
    ///Значение для нового интервала. При добавлении нового интервала он всегда будет временным и с указанным значением
    private var newInterval = "5.0"
    
    private var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableOfTraining.delegate = self
        self.tableOfTraining.dataSource = self
        
        if let data = SaverLoader.load(for: "trainOptions") {
            self.training = data

            tableOfTraining.reloadData()

            numberOfRounds.text = "Кол-во раундов: \(self.training[0][0])"
            stepperNumOfRounds.value = Double(self.training[0][0]) ?? 0.0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let tmpTrain = ["train" : self.training]
        notificationCenter.post(name: .training, object: self, userInfo: tmpTrain)
        
        clouserTableTraining?(training)
    }
    
    @IBAction func addTimeAction(_ sender: Any) {

        if training.indices.contains(1) {
            training[1].append(newInterval)
        } else if training.indices.contains(0) {
            training.append([newInterval])
        } else {
            training.append(["1"])
            training.append([newInterval])
        }
        
        tableOfTraining.reloadData()
        let train = ["train" : self.training]
        notificationCenter.post(name: .training, object: self, userInfo: train)
        
        SaverLoader.save(value: self.training, for: "trainOptions")
        print("Сохранение при добавлении интервала", self.training)
    }
    
    @IBAction func stepperForNumRoundsAction(_ sender: UIStepper) {
        let tmpValue = Int(sender.value)
        numberOfRounds.text = "Кол-во раундов: \(tmpValue)"
        
        if training.indices.contains(0) {
            training[0][0] = String(tmpValue)
        } else {
            training.append([String(tmpValue)])
            training.append([newInterval])
        }
        
        let notifTrain = ["train" : self.training]
        notificationCenter.post(name: .training, object: self, userInfo: notifTrain)
        
        SaverLoader.save(value: self.training, for: "trainOptions")
        print("Сохранение при изменении кол-ва раундов", self.training)
    }
}

extension ViewControllerOptionsTraining: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var tt = 0
        
        if training.indices.contains(1) {
            tt = training[1].count
        }
        
        return tt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOptions", for: indexPath) as! CellOptionsTraining
        
        if self.training[1][indexPath.row].contains("."), let tmpDouble = Double(self.training[1][indexPath.row]) {
            cell.time.isHidden = false
            cell.rep.isHidden = true
            cell.segmentControlTrain.selectedSegmentIndex = 0
            //Нужно делить на 5, т.к. stepperTime возвращает данные умноженные на 5
            cell.stepperTime.value = tmpDouble / 5
            cell.time.text = "Интервал \(TimeFormatter.formatter(time: tmpDouble))"
            
            cell.clouserStepperValue = { item in
            
                self.training[1][indexPath.row] = "\(item)"
                self.clouserTableTraining?(self.training)
                
                let train = ["train" : self.training]
                self.notificationCenter.post(name: .training, object: self, userInfo: train)
                SaverLoader.save(value: self.training, for: "trainOptions")
            }
            
            return cell
            
        } else if let tmpInt = Int(self.training[1][indexPath.row]) {
            cell.time.isHidden = true
            cell.rep.isHidden = false
            cell.segmentControlTrain.selectedSegmentIndex = 1
            cell.stepperTime.value = Double(tmpInt)
            cell.rep.text = "Повторов: \(tmpInt)"
            
            cell.clouserStepperValue = { item in
            
                self.training[1][indexPath.row] = "\(item)"
                self.clouserTableTraining?(self.training)
                
                let train = ["train" : self.training]
                self.notificationCenter.post(name: .training, object: self, userInfo: train)
                SaverLoader.save(value: self.training, for: "trainOptions")
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
            training[1].remove(at: indexPath.row)
            clouserTableTraining?(training)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let train = ["train" : self.training]
            self.notificationCenter.post(name: .training, object: self, userInfo: train)
            
            tableOfTraining.reloadData()

            SaverLoader.save(value: self.training, for: "trainOptions")
        }
    }
}
