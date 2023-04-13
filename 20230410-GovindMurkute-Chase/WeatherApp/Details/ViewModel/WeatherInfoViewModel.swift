//
//  WeatherInfoViewModel.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation
import UIKit

protocol WeatherViewModelDelegate {
/// Triggers when Weather API call get fininshed.
    func weatherLoaded()
    
/// Triggers when Weather icon fetch finished.
    func weatherIconData(image: UIImage)
}

class WeatherInfoViewModel {
    
    let provider: any ServiceProviderProtocol<WearhterService>
    var delegate: WeatherViewModelDelegate?
    var weatherInfo: WeatherInfo?

    var location: GeoLocationModel? {
        didSet {
            self.fetchWeather(completion: { })
        }
    }
    
    var imageUrl: URL? {
        didSet {
            self.fetchWeatherIcon()
        }
    }

    init(provider: any ServiceProviderProtocol<WearhterService>) {
        self.provider = provider
    }
    
///  Fetch weather details from server by providing lon & lat got from geo API call.
    func fetchWeather(completion: @escaping (() -> ())) {
        
        let lan = (location?.lat ?? 0.0).stringValue()
        let long = (location?.lon ?? 0.0).stringValue()
        provider.load(type: WeatherInfo.self, service: .getWeather(lat: lan, long: long)) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let data, _):
                self.weatherInfo = data
                self.delegate?.weatherLoaded()
                completion()
                
            case .failure(let error, _):
                completion()
                print(error)
            }
        }
    }
    
/// Fetch weather condition icon from open weather service and cache it.
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
