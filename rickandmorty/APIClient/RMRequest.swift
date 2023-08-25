//
//  RMRequest.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import Foundation
 
final class RMRequest{
    private struct Constants {
        static let baseurl = "https://rickandmortyapi.com/api"
    }

     let endpoint : RMEndPoint
    private var pathComponents : [String] = []
    private var queryparameters : [URLQueryItem] = []
    
    private var urlString : String {
       
        var string = Constants.baseurl
        string += "/"
        string +=  endpoint.rawValue
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                    string += "/\($0)"
            })
        }
        if !queryparameters.isEmpty {
            string += "?"
            
            let argumentString = queryparameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
            
        }
        return string
    }
    public let httpMethod = "GET"
    
    public var url : URL? {
        return URL(string: urlString)
        
    }
    public init(endpoint: RMEndPoint, pathComponents: [String] = [], queryparameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryparameters = queryparameters
    }
    convenience init?(url : URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseurl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of:Constants.baseurl + "/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.split(separator: "/").map { String($0) }
            if !components.isEmpty{
                let endpointstring = components[0]
                var pathComponents : [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                  
                }
                if let rmendpoint = RMEndPoint(rawValue: String(endpointstring)) {
                    self.init(endpoint: rmendpoint,pathComponents: pathComponents)
                    return
                }
            }
        }else if trimmed.contains("?"){
            let components = trimmed.split(separator: "?")
            if !components.isEmpty,components.count >= 2{
                let endpointstring = components[0]
                let stringqueryitems = components[1]
                let queryitem : [URLQueryItem] = stringqueryitems.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                if let rmendpoint = RMEndPoint(rawValue: String(endpointstring)) {
                    self.init(endpoint: rmendpoint,queryparameters: queryitem   )
                    return
                }
            }
            
            
        }
        return nil
    }
    
}
extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
    static let listLocationRequest = RMRequest(endpoint: .location)
}
