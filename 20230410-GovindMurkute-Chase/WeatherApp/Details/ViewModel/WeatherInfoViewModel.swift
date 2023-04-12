//
//  WeatherInfoViewModel.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate {
    func weatherLoaded()
    func weatherIconData(image: UIImage)
}

class WeatherInfoViewModel {
    
    let provider = ServiceProvider<WearhterService>()
    var delegate: WeatherViewModelDelegate?
    var weatherInfo: WeatherInfo?
    
    var location: GeoLocationModel? {
        didSet {
            self.fetchWeather()
        }
    }
    
    var imageUrl: URL? {
        didSet {
            self.fetchWeatherIcon()
        }
    }

    private func fetchWeather() {
        
        // Make API call
        let lan = String(format: "%f", location?.lat ?? 0.0)
        let long = String(format: "%f", location?.lon ?? 0.0)
        provider.load(service: .getWeather(lat: lan, long: long)) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                // Populating Weather info
                self.weatherInfo = try? decoder.decode(WeatherInfo.self, from: response)
                self.delegate?.weatherLoaded()
                
            case .failure(let error):
                print(error.localizedDescription)
                
            case .empty:
                print("No data")
            }
        }
    }
    
    private func fetchWeatherIcon() {
        guard let url = imageUrl else { return }
        
        if let cacheImage = AppCache.shared.imageCache.object(forKey: url.absoluteString) {
            self.delegate?.weatherIconData(image: cacheImage)
        } else {
            provider.getWeatherImage(url: url) { data, error  in
                if let weatherImage = self.image(data: data) {
                AppCache.shared.imageCache.setObject(weatherImage, forKey: url.absoluteString)
                    self.delegate?.weatherIconData(image: weatherImage)
                } else {
                    print("error while loading image")
                }
            }
        }
    }
    
    private func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "picture")
    }
}
