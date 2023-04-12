//
//  WeatherDetailsViewController.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherSubtitle: UILabel!

    var coordinator: MVVMCoordinator?
    var viewModel = WeatherInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setLocation(with location: GeoLocationModel) {
        self.viewModel.delegate = self
        self.viewModel.location = location
        self.title = "Weather"
        savelastSearch()
    }
    
    private func savelastSearch() {
        UserDefaults.standard.set(self.viewModel.location?.lat, forKey: "lat")
        UserDefaults.standard.set(self.viewModel.location?.lon, forKey: "lon")
    }
}

extension WeatherDetailsViewController: WeatherViewModelDelegate {
    
    func weatherLoaded() {
        
        guard let weather = viewModel.weatherInfo else { return }
        self.cityLabel.text = weather.name
        self.weatherTitle.text = weather.weather?.first?.main
        self.weatherSubtitle.text = weather.weather?.first?.description
        guard let temperature = weather.main?.temp else { return }
        self.temperatureText.text = String(describing: temperature) + " °C"
        
        if let icon = weather.weather?.first?.icon,
           let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(String(describing: icon))@2x.png") {
            
            self.viewModel.imageUrl = imageUrl
        }
    }
    
    func weatherIconData(image: UIImage) {
        
        DispatchQueue.main.async {
            // set Image
            self.weatherIcon.image = image
        }
    }
}
