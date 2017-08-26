//
//  WeatherDetailsViewController.swift
//  RxRepository
//
//  Created by Travis Smith on 8/22/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var zipCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(zipCode ?? "") Weather"

        contentView.isHidden = true
        
        let realm = try! Realm()
        WeatherRepository(realm: realm)
            .fetchWeather(withZipCode: zipCode)
            .subscribe(onNext: { (weatherResponse) in
                self.locationNameLabel.text = weatherResponse.name
                
                if let coordinate = weatherResponse.coordinate {
                    self.coordinatesLabel.text = coordinate.description
                }
                
                if let mainWeather = weatherResponse.main {
                    self.temperatureLabel.text = mainWeather.temperature.description
                    self.humidityLabel.text = mainWeather.humidity.description
                    self.pressureLabel.text = mainWeather.pressure.description
                }
                
                self.contentView.isHidden = false
            }) { (error) in
                let alert = UIAlertController(title: "Error", message: "Zip code '\(self.zipCode!)' does not exist." , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }.addDisposableTo(disposeBag)
    }
}
