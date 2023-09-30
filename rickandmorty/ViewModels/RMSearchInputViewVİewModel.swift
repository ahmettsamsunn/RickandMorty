//
//  RMSearchInputViewVİewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.08.2023.
//

import Foundation
final class RMSerachInputViewViewModel {
    private let type : RMSearchViewController.Config.`Type`
    enum DynamicOption : String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument : String {
            switch self {
            case .status :  return "status"
            case .gender : return "gender"
            case .locationType : return "type"
            }
        }
        
        var choices : [String]{
            switch self{
            case .status :
                return ["alive","dead","unknown"]
            case .gender :
                return ["female","male","genderless","unknown"]
            case .locationType :
                return ["cluster","planet","microverse"]
            }
            
        }
    }
    init(type : RMSearchViewController.Config.`Type`){
        self.type = type
    }
    public var hasDynamicOptions:Bool {
        switch self.type {
        case .character , .location :
            return true
        case .episode :
            return false
        }
    }
    public var options : [DynamicOption]{
        switch self.type {
        case .character :
            return [.status,.gender]
        case .location :
            return [.locationType]
        case .episode :
            return []
        }

    }
    public var searchPlaceHolderText : String{
        switch self.type {
        case .character :
            return "Karakter İsmi"
        case .location :
            return "Lokasyon İsmi"
        case .episode :
            return "Bölüm İsmi"
        }

    }
}
