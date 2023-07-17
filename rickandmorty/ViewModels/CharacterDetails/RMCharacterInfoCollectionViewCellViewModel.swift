//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import Foundation
import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private let value: String

    static let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    static let shortdateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()


    public var title: String {
        type.displayTitle
    }

    public var displayValue: String {
        if value.isEmpty {
            return "none"
        }
        if let date1 = Self.dateformatter.date(from: value), type == .created {
         
            return Self.shortdateformatter.string(from: date1)
        }
        return value
    }

    public var iconImage: UIImage? {
        return type.iconImage(value)
    }

    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount

        var displayTitle: String {
            switch self {
            case .status, .gender, .type, .species, .origin, .created, .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPİSODE COUNT"
            }
        }

        
        func iconImage(_ status: String) -> UIImage? {
            switch self {
            case .status:
                
                switch RMCharacterStatus(rawValue: status) {
                case .alive:
                    return UIImage(systemName: "circle.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
                case .dead:
                    return UIImage(systemName: "circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                case .unknown:
                    return UIImage(systemName: "circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                default:
                    return UIImage(systemName: "circle.fill")?.withTintColor(.gray)
                }
            case .gender:
                return UIImage(systemName: "person.crop.circle")
                case .origin:
                return UIImage(systemName: "mappin.and.ellipse")
            case .location:
            return UIImage(systemName: "location.circle")
                    default:
                return UIImage(systemName: "bell")
            }
        }
    }

    init(type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
}

// Continue with the rest of your code ...
