//
//  DictionaryExtensions.swift
//  RxRepository
//
//  Created by Travis Smith on 8/9/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    
    var asQueryParameters: String {
        return map({"\($0)=\($1)"}).joined(separator: "&")
    }
}
