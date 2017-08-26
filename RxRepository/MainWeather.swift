//
//  MainWeather.swift
//  RxRepository
//
//  Created by Travis Smith on 8/8/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RealmSwift

class MainWeather: Object {
    
    dynamic var temperature: Double = 0.0
    dynamic var humidity: Double = 0.0
    dynamic var pressure: Double = 0.0
    
    convenience init(model: [String: Any]) {
        self.init()
        temperature = model["temp"] as? Double ?? temperature
        humidity = model["humidity"] as? Double ?? humidity
        pressure = model["pressure"] as? Double ?? pressure
    }
}
