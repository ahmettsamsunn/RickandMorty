//
//  RMCharacterStatus.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import Foundation
import UIKit
enum RMCharacterStatus:String,Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    var text: String {
        switch self {
        case .alive, .dead,.unknown:
            return rawValue
        
        }
    }
    
}
