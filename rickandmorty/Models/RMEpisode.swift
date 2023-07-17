//
//  RMEpisode.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 23.06.2023.
//

import Foundation
struct RMEpisode : Codable,RMEpisodeDataReader {
    let id : Int
    let name : String
    let air_date : String
    let episode: String
    let characters : [String]
    
    let url: String
    let created : String
}
