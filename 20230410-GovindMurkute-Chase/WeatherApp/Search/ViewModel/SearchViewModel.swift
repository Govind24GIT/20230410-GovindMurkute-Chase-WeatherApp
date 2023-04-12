//
//  SearchViewModel.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

class SearchViewModel {
    var geoLocationList: [GeoLocationModel]?
    let provider = ServiceProvider<WearhterService>()

    var reloadUI: () -> Void = { }
    var isLoading: Bool = false {
        didSet {
            self.reloadUI()
        }
    }

    func performSearch(text: String) {
        guard !text.isEmpty else {
            self.geoLocationList?.removeAll()
            self.reloadUI()
            return
        }
        isLoading = true
        
        // Make API call
        provider.load(service: .geoSearch(city: text)) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                // Populating ResultList variable
                self.geoLocationList = try? decoder.decode([GeoLocationModel].self, from: response)
                self.isLoading = false
                
            case .failure(let error):
                print(error.localizedDescription)
                
            case .empty:
                print("No data")
            }
        }
    }
}
