//
//  WeatherListViewController.swift
//  RxRepository
//
//  Created by Travis Smith on 8/22/17.
//  Copyright © 2017 Travis Smith. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherListViewController: UIViewController {

    fileprivate let cellIdentifier = "Cell"
    fileprivate let segueIdentifier = "WeatherDetailsSegue"
    fileprivate let dateFormatter = DateFormatter()
    
    fileprivate var savedWeatherResponses: Results<WeatherResponse>!
    fileprivate var realm: Realm!
    fileprivate var selectedZipCode = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm:ss a"
        
        realm = try! Realm()
        savedWeatherResponses = realm.objects(WeatherResponse.self).sorted(byKeyPath: "zipCode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier,
            let destination = segue.destination as? WeatherDetailsViewController,
            identifier == segueIdentifier {
            
            destination.zipCode = selectedZipCode
        }
    }
}

extension WeatherListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let zipCode = searchBar.text else {
            return
        }
        
        selectedZipCode = zipCode
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
}

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWeatherResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = fetchBaseCell(forTableView: tableView, atIndexPath: indexPath)
        let weatherResponse = savedWeatherResponses[indexPath.row]
        
        cell.textLabel?.text = "\(weatherResponse.zipCode) - \(weatherResponse.name)"
        cell.detailTextLabel?.text = "As of \(dateFormatter.string(from: weatherResponse.lastUpdated))"
        
        return cell
    }
    
    private func fetchBaseCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let weatherResponse = savedWeatherResponses[indexPath.row]
        selectedZipCode = weatherResponse.zipCode
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
}
