//
//  SaverLoader.swift
//  Timer
//
//  Created by cladendas on 21.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import Foundation

///Класс для сохранения в память и получения из памяти данных
class SaverLoader {
    ///Получает объект value: Any? для сохранения и его ключ key: String
    static func save(value: [[String]]?, for key: String) {
        
        guard let ff = value else { return }

        var qq = [[String]]()
        
        qq = ff as! [[String]]

        
        print("wwwwwww", qq)
        
//        var gg = value!.forEach { round in
//            return round.map { interval in interval as! String }
//        }
        
        
 
        print("Будут сохраняться данные: ", value)
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()

    }
    ///Для загрузки из памяти использует ключ key: String и вернёт найденные данные, а если их нет, то вернёт nil
    static func load(for key: String) -> [[String]]? {
        
        if let ff = UserDefaults.standard.object(forKey: key) as? [[String]] {
            print("Загружаются данные: ", ff)
            return ff
        }
        
//        let gg: [[Any]] = [[1, 20.0, 1, 25.0], [1, 20.0, 1, 25.0]]
        
        return nil
    }
}
