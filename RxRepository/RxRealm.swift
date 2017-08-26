//
//  RxRealm.swift
//  RxRepository
//
//  Created by Travis Smith on 8/9/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

enum RxRealm {
    
    static func asObservable<T: Object>(_ object: T) -> Observable<T> {
        
        return Observable<T>.create({ (observer) -> Disposable in
            
            observer.onNext(object)
            
            let token = object.addNotificationBlock({ (change) in
                
                observer.onNext(object)
            })
            
            return Disposables.create {
                
                token.stop()
            }
        })
    }

    static func asObservable<U: Results<Object>>(_ results: U) -> Observable<U> {
        
        return Observable<U>.create({ (observer) -> Disposable in
            
            observer.onNext(results)
            
            let token = results.addNotificationBlock({ (change) in
                
                observer.onNext(results)
            })
            
            return Disposables.create {
                
                token.stop()
            }
        })
    }
}
