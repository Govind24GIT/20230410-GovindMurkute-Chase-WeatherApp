//
//  ServiceProvider.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}

class ServiceProvider<T: Service> {
    var urlSession = URLSession.shared

    init() { }

    func load(service: T, completion: @escaping (Result<Data>) -> Void) {
        call(service.urlRequest, completion: completion)
    }
    
    func getWeatherImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        weatherImageCall(url: url, completion: completion)
    }
}

extension ServiceProvider {
    
    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                deliverQueue.async {
                    completion(.failure(error))
                }
            } else if let data = data {
                deliverQueue.async {
                    completion(.success(data))
                }
            } else {
                deliverQueue.async {
                    completion(.empty)
                }
            }
        }.resume()
    }
    
    private func weatherImageCall(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
        let task = urlSession.downloadTask(with: url) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, error)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
