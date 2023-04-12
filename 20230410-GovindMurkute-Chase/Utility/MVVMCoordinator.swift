//
//  MVVMCoordinator.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit

final class MVVMCoordinator: Coordinator {
    var coordinator: [Coordinator] = []
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController.initFromNib()
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func showWeatherDetails(for location: GeoLocationModel) {
        let weatherDetailVC = WeatherDetailsViewController.initFromNib()
        weatherDetailVC.setLocation(with: location)
        weatherDetailVC.coordinator = self
        navigationController.pushViewController(weatherDetailVC, animated: true)
    }
}
