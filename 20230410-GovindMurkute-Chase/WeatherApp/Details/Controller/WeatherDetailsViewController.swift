//
//  WeatherDetailsViewController.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit
import Foundation
import SwiftUI

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherSubtitle: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var coordinatesButton: UIButton!

    var coordinator: MVVMCoordinator?
    var viewModel = WeatherInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
///  Passing the location with coordinates from geo search API on table row selection
    func setLocation(with location: GeoLocationModel) {
        self.viewModel.delegate = self
        self.viewModel.location = location
        self.title = "Weather"
        saveLastSearch()
    }
    
///     Persisting coordinates of last searched location
    private func saveLastSearch() {
        UserDefaults.standard.set(self.viewModel.location?.lat, forKey: "lat")
        UserDefaults.standard.set(self.viewModel.location?.lon, forKey: "lon")
    }
    
    
    @IBAction func coordinatesDetails(_ sender: UIButton) {
        let coordinatesView = UIHostingController(rootView: CoordinatesView(latitude: String(format: "%f", viewModel.location?.lat ?? 0.0), longitude: String(format: "%f", viewModel.location?.lon ?? 0.0)))
        coordinator?.navigationController.pushViewController(coordinatesView, animated: true)
    }
}

// MARK: - WeatherViewModelDelegate
extension WeatherDetailsViewController: WeatherViewModelDelegate {
    
    func weatherLoaded() {
        guard let weatherInfo = viewModel.weatherInfo else { return }
        self.cityLabel.text = weatherInfo.name
        self.weatherTitle.text = weatherInfo.weather?.first?.main
        self.weatherSubtitle.text = weatherInfo.weather?.first?.description
        guard let temperature = weatherInfo.main?.temp,
              let minTemp = weatherInfo.main?.temp_min,
              let maxTemp = weatherInfo.main?.temp_max else { return }
        self.temperatureText.text = String(describing: temperature) + " °C"
        self.minTemp.text = "Min Temp:   " + String(describing: minTemp)
        self.maxTemp.text = "Max Temp:   " + String(describing: maxTemp)

        if let icon = weatherInfo.weather?.first?.icon,
           let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(String(describing: icon))@2x.png") {
            
            self.viewModel.imageUrl = imageUrl
        }
    }

/// Setting weather image to imageview callback
    func weatherIconData(image: UIImage) {
        DispatchQueue.main.async {
            self.weatherIcon.image = image
        }
    }
}
