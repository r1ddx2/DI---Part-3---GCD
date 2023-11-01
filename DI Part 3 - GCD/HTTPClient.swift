//
//  HTTPClient.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

// MARK: - Error
enum HTTPError: Error {
    case urlSessionError(Error)
    case serverError
    case clientError(Data)
    case invalidResponse
}

// MARK: - Request
protocol HTTPRequest {
    var endPoint: String { get }
}

extension HTTPRequest {
    
    func makeRequest() -> URLRequest {
        let urlString = "https://data.taipei/api/v1/dataset/c7784a9f-e11e-4145-8b72-95b44fdc7b83" + endPoint
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        return request
    }
}

// MARK: - HTTPClient
protocol HTTPClientProtocol {
    func request(_ HTTPRequest: HTTPRequest, completion: @escaping (Result<Data, HTTPError>) -> Void )
}

class HTTPClient: HTTPClientProtocol {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func request(
        _ HTTPRequest: HTTPRequest,
        completion: @escaping (Result<Data, HTTPError>) -> Void) {
            
            URLSession.shared.dataTask(
                with: HTTPRequest.makeRequest(),
                completionHandler: { (data, response, error) in
          
                    // Check error
                    if let error = error {
                        completion(.failure(.urlSessionError(error)))
                        return
                    }
                    
                    // Check response
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    // Check status code
                    let statusCode = httpResponse.statusCode
                    switch statusCode {
                    case 200..<300:
                        completion(.success(data!))
                    case 400..<500:
                        completion(.failure(.clientError(data!)))
                    case 500..<600:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.invalidResponse))
                    }
                    
                }).resume()
                    
                    
                    
                
    }
    

    
   
    
    
    
}
