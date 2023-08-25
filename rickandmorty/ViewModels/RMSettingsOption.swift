//
//  RMSettingsOption.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 17.07.2023.
//
import UIKit
import Foundation
enum RMSettingsOption : CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targerURL : URL? {
        switch self {
        case .rateApp:
          return  nil
        case .contactUs:
            return URL(string: "https://www.linkedin.com/in/ahmet-samsun-3b050222a/")
        case .terms:
            return nil
        case .privacy:
            return nil
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            return nil
        case .viewCode:
            return URL(string: "https://github.com/ahmettsamsunn/RickandMorty")
        }
    }
    var displaytitle : String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return  "Contact Us"
        case .terms:
            return   "Terms of Service"
        case .privacy:
            return  "Privacy Policy"
        case .apiReference:
            return  "API Reference"
        case .viewSeries:
            return  "View Series"
        case .viewCode:
            return   "View App Code"
        }
    }
    var iconimage : UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    var iconContainerColor : UIColor {
        switch self {
        case .rateApp:
            return .systemGreen
        case .contactUs:
            return .systemRed
        case .terms:
            return .systemMint
        case .privacy:
            return .systemBlue
        case .apiReference:
            return .systemTeal
        case .viewSeries:
            return .systemOrange
        case .viewCode:
            return .systemGray4
        }
    }
}
