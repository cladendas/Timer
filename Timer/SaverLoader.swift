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
    static func save(value: Any?, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    ///Для загрузки из памяти использует ключ key: String и вернёт найденные данные, а если их нет, то вернёт nil
    static func load(for key: String) -> Any? {
        if let data = UserDefaults.standard.object(forKey: key) {
            return data
        } else {
            return nil
        }
    }
}
