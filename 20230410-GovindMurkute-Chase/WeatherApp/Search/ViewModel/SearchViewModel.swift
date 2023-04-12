//
//  SearchViewModel.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

class SearchViewModel {
    var geoLocationList: [GeoLocationModel]?
    var errorMessage: String?
    let provider = ServiceProvider<WearhterService>()

    var reloadUI: () -> Void = { }
    var isLoading: Bool = false {
        didSet {
            self.reloadUI()
        }
    }

/// Call to GeoCoder api to get coordinates of location passed.
    func performSearch(text: String) {
        guard !text.isEmpty else {
            self.geoLocationList?.removeAll()
            self.reloadUI()
            return
        }
        isLoading = true
        
        provider.load(service: .geoSearch(city: text)) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let data, _):
                let decoder = JSONDecoder()
                self.geoLocationList = try? decoder.decode([GeoLocationModel].self, from: data)
                self.isLoading = false
                self.errorMessage = nil

            case .failure(let error, _):
                print(error)
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
