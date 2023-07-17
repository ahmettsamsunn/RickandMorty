//
//  RMAPICacheManager.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 10.07.2023.
//

import Foundation
final class RMAPIChacheManager {
    private var cacheDictionary : [ RMEndPoint:NSCache<NSString,NSData>] = [:]
    init() {
        setupCache()
    }
    
    
    public func CachedRedponse(for endpoint: RMEndPoint,url : URL?) -> Data?{
        guard let targetCache = cacheDictionary[endpoint],let url = url else {
            return nil
    }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
        
 }
    public func setCache(for endpoint: RMEndPoint,url : URL?,data:Data){
        guard let targetCache = cacheDictionary[endpoint],let url = url else {
            return
    }
        let key = url.absoluteString as NSString
        return targetCache.setObject(data as NSData, forKey: key)
        
    
 }
    
    private func setupCache(){
        RMEndPoint.allCases.forEach ({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString,NSData>()
        })
    }
}
