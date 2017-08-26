//
//  APIError.swift
//  RxRepository
//
//  Created by Travis Smith on 8/9/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case invalidURL
    case invalidResponse
    case invalidZipCode
}
