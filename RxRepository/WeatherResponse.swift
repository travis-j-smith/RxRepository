//
//  WeatherResponse.swift
//  RxRepository
//
//  Created by Travis Smith on 8/8/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherResponse: Object {
    
    dynamic var zipCode: String = ""
    dynamic var name: String = ""
    dynamic var coordinate: Coordinate?
    dynamic var main: MainWeather?
    dynamic var lastUpdated: Date = Date()
    
    override class func primaryKey() -> String? {
        return "zipCode"
    }
    
    convenience init(zipCode: String, model: [String: Any]) {
        self.init()
        
        self.zipCode = zipCode
        name = model["name"] as? String ?? self.name
        coordinate = Coordinate(model: model["coord"] as? [String: Any] ?? [:])
        main = MainWeather(model: model["main"] as? [String: Any] ?? [:])
        lastUpdated = Date()
    }
}
