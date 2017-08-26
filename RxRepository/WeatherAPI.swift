//
//  WeatherAPI.swift
//  RxRepository
//
//  Created by Travis Smith on 8/8/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherAPI {
    
    static let shared = WeatherAPI()
    
    let baseURL = "https://api.openweathermap.org/data/2.5"
    
    var baseQueryParams = [String: String]()
    
    private init() {
        
        guard let keysPlistUrl = Bundle.main.url(forResource: "Keys", withExtension: "plist"),
            let keysPlistData = try? Data(contentsOf: keysPlistUrl) else {
                
                fatalError("Cannot find Keys.plist")
        }
        
        guard let keysPlist = try? PropertyListSerialization.propertyList(from: keysPlistData, options: [], format: nil),
            let keysDict = keysPlist as? [String: Any] else {
                
                fatalError("Cannot interpret Keys.plist as a Dictionary")
        }
        
        guard let apiKey = keysDict["WeatherAPIKey"] as? String else {
            
            fatalError("Cannot find WeatherAPIKey in Keys.plist")
        }
        
        baseQueryParams["appid"] = apiKey
        baseQueryParams["units"] = "imperial"
    }
    
    func fetchCurrentWeather(withZip zipCode: String) -> Single<WeatherResponse> {
        
        var params = baseQueryParams
        params["zip"] = "\(zipCode),us"
        
        let urlString = "\(baseURL)/weather?\(params.asQueryParameters)"
        
        guard let url = URL(string: urlString) else {
            return Single.error(APIError.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.rx.response(request: urlRequest)
            .asSingle()
            .map({ (response: (HTTPURLResponse, Data)) -> WeatherResponse in
            
                guard let jsonObject = try? JSONSerialization.jsonObject(with: response.1, options: []),
                    let jsonDict = jsonObject as? [String: Any] else {
                    
                    throw APIError.invalidResponse
                }
                
                guard response.0.statusCode == 200 else {
                    
                    throw APIError.invalidZipCode
                }
                
                return WeatherResponse(zipCode: zipCode, model: jsonDict)
        })
    }
}
