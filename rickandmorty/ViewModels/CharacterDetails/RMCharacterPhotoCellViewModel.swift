//
//  RMCharacterPhotoCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import Foundation
final class RMCharacterPhotoCollectionViewCellViewModel {
    public let imageUrl : URL?
    init(imageUrl : URL?) {
        self.imageUrl = imageUrl
    }
    public func fetchImage(completion : @escaping(Result<Data,Error>) -> Void ) {
        guard let imageUrl = imageUrl else {
            return
        }
        RMImageLoader.shared.downloadimage(imageUrl, completion: completion)
    }
}
