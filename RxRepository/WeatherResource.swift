//
//  WeatherResource.swift
//  RxRepository
//
//  Created by Travis Smith on 8/22/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct WeatherResource: NetworkBoundRealmResource {
    
    typealias T = WeatherResponse
    
    private let zipCode: String
    private var realm: Realm
    
    init(zipCode: String, realm: Realm) {
        self.zipCode = zipCode
        self.realm = realm
    }
    
    func fetchLocalResource() -> Single<WeatherResponse?> {
        
        let predicate = NSPredicate(format: "zipCode = %@", zipCode)
        return Single.just(realm.objects(WeatherResponse.self).filter(predicate).first)
    }
    
    func fetchRemoteResource() -> Single<WeatherResponse> {
        
        return WeatherAPI.shared.fetchCurrentWeather(withZip: zipCode)
    }
    
    func shouldUpdate(_ t: WeatherResponse) -> Bool {
        
        return t.lastUpdated.addingTimeInterval(60).compare(Date()) == ComparisonResult.orderedAscending
    }
    
    func save(_ t: WeatherResponse) -> Single<WeatherResponse> {
        
        return Single<WeatherResponse>.create(subscribe: { (event) -> Disposable in
            do {
                try self.realm.write {
                    self.realm.add(t, update: true)
                }
            } catch {
                event(.error(error))
            }
            event(.success(t))
            
            return Disposables.create()
        })
    }
}
