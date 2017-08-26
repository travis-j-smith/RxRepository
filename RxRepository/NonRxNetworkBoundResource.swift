//
//  NonRxNetworkBoundResource.swift
//  RxRepository
//
//  Created by Travis Smith on 8/9/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias AsyncRequest<T> = (Result<T>) -> Void

protocol NonRxNetworkBoundResource {
    
    associatedtype T
    
    func asyncFetch(_ callback: AsyncRequest<T>)
    
    func fetchLocalResource(_ request: AsyncRequest<T?>)
    func fetchRemoteResource(_ request: AsyncRequest<T>)
    func shouldUpdate(_ t: T) -> Bool
    func save(_ t: T, asyncRequest: AsyncRequest<T>)
    func asAsyncRequest(_ t: T, asyncRequest: AsyncRequest<T>)
}

extension NonRxNetworkBoundResource {
    
    func asyncFetch(_ callback: @escaping AsyncRequest<T>) {
        fetchLocalResource { (localResult) in
            if case .success(let localValue) = localResult {
                if let localValue = localValue, !shouldUpdate(localValue) {
                    asAsyncRequest(localValue, asyncRequest: callback)
                } else {
                    fetchRemoteResource({ (remoteResult) in
                        guard case .success(let remoteValue) = remoteResult else {
                            callback(remoteResult)
                            return
                        }
                        save(remoteValue, asyncRequest: { (savedRequest) in
                            guard case .success(let savedValue) = savedRequest else {
                                callback(savedRequest)
                                return
                            }
                            asAsyncRequest(savedValue, asyncRequest: callback)
                        })
                    })
                }
            } else if case .failure(let error) = localResult {
                callback(.failure(error))
            }
        }
    }
    
    func asAsyncRequest(_ t: T, asyncRequest: AsyncRequest<T>) {
        asyncRequest(.success(t))
    }
}
