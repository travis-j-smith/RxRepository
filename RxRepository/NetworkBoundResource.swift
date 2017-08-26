//
//  NetworkBoundResource.swift
//  RxRepository
//
//  Created by Travis Smith on 8/7/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkBoundResource {
    
    associatedtype T
    
    var observable: Observable<T> { get }
    
    func fetchLocalResource() -> Single<T?>
    func fetchRemoteResource() -> Single<T>
    func shouldUpdate(_ t: T) -> Bool
    func save(_ t: T) -> Single<T>
    func asObservable(_ t: T) -> Observable<T>
}

extension NetworkBoundResource {
    
    var observable: Observable<T> {
        
        return fetchLocalResource()
            .asObservable()
            .flatMap({ (loadedLocalInstance) -> Observable<T> in
                if let loadedLocalInstance = loadedLocalInstance, !self.shouldUpdate(loadedLocalInstance) {
                    return self.asObservable(loadedLocalInstance)
                } else {
                    return self.fetchRemoteResource()
                        .observeOn(MainScheduler.instance)
                        .flatMap({self.save($0)})
                        .asObservable()
                        .flatMap({ (loadedRemoteInstance) -> Observable<T> in
                            return self.asObservable(loadedRemoteInstance)
                        })
                }
            })
    }
    
    func asObservable(_ t: T) -> Observable<T> {
        return Observable.just(t)
    }
}

class RxExample: NetworkBoundResource {
    
    typealias T = String
    
    func fetchLocalResource() -> Single<String?> {
        print("Fetching local")
        return Single.just(nil)
    }
    
    func fetchRemoteResource() -> Single<String> {
        print("Fetching remote")
        return Single.just("Remote")
    }
    
    func shouldUpdate(_ t: String) -> Bool {
        print("Should update")
        return true
    }
    
    func save(_ t: String) -> Single<T> {
        
        return Single<String>.create { (event) -> Disposable in
            print("Saving")
            event(SingleEvent.success("Saving"))
            return Disposables.create()
        }.delay(2.0, scheduler: MainScheduler.instance)
    }
    
    func asObservable(_ t: String) -> Observable<String> {
        print("As Observable")
        return Observable.just(t)
    }
}
