//
//  WeatherRepository.swift
//  RxRepository
//
//  Created by Travis Smith on 8/9/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class WeatherRepository {
    
    private var realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetchWeather(withZipCode zipCode: String) -> Observable<WeatherResponse> {
        
        return WeatherResource(zipCode: zipCode, realm: realm).observable
    }
}
