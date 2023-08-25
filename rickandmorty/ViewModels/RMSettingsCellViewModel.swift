//
//  RMSettingsCellViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 17.07.2023.
//

import Foundation
import UIKit
struct RMSettingsCellViewModel : Identifiable {
    var id = UUID()
    public let onTapHandler : (RMSettingsOption) -> Void
    
    
    public let type : RMSettingsOption
    
    public var image : UIImage? {
        type.iconimage
    }
    public var title : String {
        type.displaytitle
    }
   
    init(type : RMSettingsOption,onTapHandler : @escaping (RMSettingsOption) -> Void){
        self.type = type
        self.onTapHandler = onTapHandler
    }
    public var iconContainerColor : UIColor {
       return type.iconContainerColor
    }
}
