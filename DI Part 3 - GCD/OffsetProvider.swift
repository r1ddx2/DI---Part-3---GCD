//
//  OffsetProvider.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

typealias OffsetResponse = (Result<Root, Error>) -> Void

enum OffsetRequest: String, CaseIterable, HTTPRequest{
    case offset0
    case offset10
    case offset20

    var endPoint: String {
        switch self {
        case .offset0:
            return "?scope=resourceAquire&limit=1&offset=0"
        case .offset10:
            return "?scope=resourceAquire&limit=1&offset=10"
        case .offset20:
            return "?scope=resourceAquire&limit=1&offset=20"
        }
    }
}

class OffsetProvider {
 
    let decoder = JSONDecoder()
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
  
    // MARK: - Methods
    func fetchOffset(
        request: OffsetRequest,
        completion: @escaping OffsetResponse) {
            
            httpClient.request(request) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let response = try self.decoder.decode(Root.self, from: data)
                        
                        completion(.success(response))
                        
                        
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                
        }
        
    }
    
}
