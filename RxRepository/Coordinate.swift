//
//  Coordinate.swift
//  RxRepository
//
//  Created by Travis Smith on 8/8/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Coordinate: Object {
    
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    convenience init(model: [String: Any]) {
        self.init()
        
        latitude = model["lat"] as? Double ?? latitude
        longitude = model["lon"] as? Double ?? longitude
    }
    
    override var description: String {
        return "(\(latitude), \(longitude))"
    }
}
