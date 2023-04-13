//
//  ServiceProvider.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
// 

import Foundation

enum Result<M, HTTPURLResponse> {
    case success(M, HTTPURLResponse)
    case failure(NetworkError, HTTPURLResponse)
}

protocol ServiceProviderProtocol<T> {
    associatedtype T: Service
    func load<M: Codable>(type: M.Type, service: T, completion: @escaping (Result<M, HTTPURLResponse>) -> Void)
    func getWeatherImage(url: URL, completion: @escaping (Data?, Error?) -> Void)
}

class ServiceProvider<T: Service>: ServiceProviderProtocol {
    var urlSession = URLSession.shared

    init() { }
    
    /// Common API method to call open weather APIs
    /// - Parameters:
    ///   - service: URL request
    ///   - completion: Return result on completion
    func load<M: Codable>(type: M.Type, service: T, completion: @escaping (Result<M, HTTPURLResponse>) -> Void) {
        call(type: type, service.urlRequest, completion: completion)
    }
    
    /// Image downloader from service
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: Return image data.
    func getWeatherImage(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        weatherImageCall(url: url, completion: completion)
    }
}

extension ServiceProvider {
    
    private func call<M: Codable>(type: M.Type, _ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<M, HTTPURLResponse>) -> Void) {
        urlSession.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let networkError = NetworkError(data: data, response: response, error: error) {
                    deliverQueue.async {
                        completion(.failure(networkError, httpResponse))
                    }
                } else {
                    if let data = data {
                        deliverQueue.async {
                            guard let model = try? JSONDecoder().decode(type.self, from: data) else { completion(.failure(.decodeError, httpResponse))
                                return
                            }
                            completion(.success(model, httpResponse))
                        }
                    } else {
                        deliverQueue.async {
                            completion(.failure(.noData, httpResponse))
                        }
                    }
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
