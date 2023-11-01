//
//  OffsetProvider.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

typealias OffsetResponse = (Result<Root, Error>) -> Void

enum OffsetRequest: HTTPRequest {
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
    
    // MARK: - Public Methods
    func fetchOffset0(completion: @escaping OffsetResponse) {
        fetchData(request: OffsetRequest.offset0, completion: completion)
    }
    func fetchOffset10(completion: @escaping OffsetResponse) {
        fetchData(request: OffsetRequest.offset10, completion: completion)
    }
    func fetchOffset20(completion: @escaping OffsetResponse) {
        fetchData(request: OffsetRequest.offset20, completion: completion)
    }
    
    // MARK: - Private Methods
    private func fetchData(
        request: OffsetRequest,
        completion: @escaping OffsetResponse) {
            
        httpClient.request(request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(Root.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                    
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
            
            
        }
        
    }
    
}
