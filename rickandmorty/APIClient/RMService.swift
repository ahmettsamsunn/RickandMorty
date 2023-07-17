//
//  RMService.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import Foundation

final class RMService{
    private let cachemanager = RMAPIChacheManager()
    static let shared = RMService()
    private init() {}
    
    public func execute<T:Codable>(_ request:RMRequest,expecting type : T.Type,completion:@escaping (Result<T,Error>) -> Void){
        if let cachedData = cachemanager.CachedRedponse(for: request.endpoint, url: request.url) {
            print("using cache")
            do {
                let result = try  JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
               
            }
            catch {
                completion(.failure(error))
            }
            return
        }
        guard let urlrequest = self.request(from: request) else {return}
        
       
        let task = URLSession.shared.dataTask(with: urlrequest) {[weak self] data, response, error in
            guard let data  = data , error == nil else {
               
                return print(error ?? "error")
            }
            do {
                let result = try  JSONDecoder().decode(type.self, from: data)
                self?.cachemanager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    private func request(from rmRequest : RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
