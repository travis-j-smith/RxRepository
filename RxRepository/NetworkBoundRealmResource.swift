//
//  NetworkBoundRealmResource.swift
//  RxRepository
//
//  Created by Travis Smith on 8/10/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol NetworkBoundRealmResource: NetworkBoundResource {
    
    associatedtype T: Object
}

extension NetworkBoundRealmResource {
    
    func asObservable(_ t: T) -> Observable<T> {
        
        return RxRealm.asObservable(t)
    }
}
