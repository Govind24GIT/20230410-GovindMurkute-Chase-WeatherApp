//
//  SearchViewController.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var coordinator: MVVMCoordinator?
    var viewModel = SearchViewModel()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search Weather for City"
        configureTableView()
        locationManager.delegate = self
        handleAutoWeather()
    }
    
    private func configureTableView() {
        let cell = UINib(nibName: String(describing: ListTableViewCell.self), bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "SearchCell")
        
        viewModel.reloadUI = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude

            let location = GeoLocationModel(name: nil, country: nil, state: nil, lat: lat, lon: long)
            coordinator?.showWeatherDetails(for: location)
        }
    }
    
    private func handleAutoWeather() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined, .restricted, .denied:
            if (UserDefaults.standard.double(forKey: "lat") != 0) {
                let lat = UserDefaults.standard.double(forKey: "lat")
                let long = UserDefaults.standard.double(forKey: "lon")
                let location = GeoLocationModel(name: nil, country: nil, state: nil, lat: lat, lon: long)
                coordinator?.showWeatherDetails(for: location)
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(text: searchText)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isLoading {
            return
        }
        if let location = viewModel.geoLocationList?[indexPath.row] {
            coordinator?.showWeatherDetails(for: location)
        }
    }
}


extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isLoading {
            return 3
        }
        else {
            return viewModel.geoLocationList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? ListTableViewCell
        
        if viewModel.isLoading {
            cell?.configureLoadingCell()
        } else {
            if let location = viewModel.geoLocationList?[indexPath.row] {
                cell?.configureCell(for: location)
            }
        }

        return cell ?? UITableViewCell()
    }
}
