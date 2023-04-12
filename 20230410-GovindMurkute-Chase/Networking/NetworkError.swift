//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Govind Murkute on 12/04/23.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
}

extension NetworkError {
    
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transportError(error)
            return
        }

        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .serverError(statusCode: response.statusCode)
            return
        }
        
        if data == nil {
            self = .noData
        }
        
        return nil
    }
}
