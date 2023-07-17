//
//  RMCharactersCollectionViewCellViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 30.06.2023.
//

import Foundation
final class RMCharactersCollectionViewCellViewModel : Hashable,Equatable {
    static func == (lhs: RMCharactersCollectionViewCellViewModel, rhs: RMCharactersCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue  == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(charactername)
        hasher.combine(characterStatusText)
        hasher.combine(characterimageurl)
    }
    
public let charactername : String
private let characterStatusText: RMCharacterStatus
private let characterimageurl : URL?
init(
        charactername : String,
        characterStatusText: RMCharacterStatus,
        characterimageurl : URL?
    ){
        self.charactername = charactername
        self.characterStatusText = characterStatusText
        self.characterimageurl = characterimageurl
    }
    public var CharacterStatusText : String {
        return "Status: \(characterStatusText.rawValue)"
    }
    public func fetchimages(completion : @escaping(Result<Data,Error>) -> Void) {
        guard let url = characterimageurl else {
            return
        }
        RMImageLoader.shared.downloadimage(url, completion: completion)
    }
}
