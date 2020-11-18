//
//  TimeFormatter.swift
//  Timer
//
//  Created by cladendas on 14.11.2020.
//  Copyright © 2020 cladendas. All rights reserved.
//

import Foundation

///Класс для вывода времени в формате MM:ss:msms
class TimeFormatter {
    
    static func formatter(time: Double) -> String {
        
        let mm = String(format: "%02d", Int(time / 60))
        let ss = String(format: "%02d", Int(time.truncatingRemainder(dividingBy: 60)))

        let b = Int(time)
        let afterPoint = time - Double(b)
        let mls = String(format: "%02d", Int(afterPoint * 100))
        
        return "\(mm):\(ss):\(mls)"
    }
}
