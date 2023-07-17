//
//  RMEndPoint.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import Foundation
@frozen enum RMEndPoint : String,Hashable,CaseIterable {
    case episode
    case character
    case location
}
