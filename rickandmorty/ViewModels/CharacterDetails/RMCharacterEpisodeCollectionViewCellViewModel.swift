//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import Foundation
protocol RMEpisodeDataReader{
    var name : String { get }
    var episode : String { get }
}
final class RMCharacterEpisodeCollectionViewCellViewModel : Hashable,Equatable {
   
    
    private var isfetching = false
    private let episodeDataUrl : URL?
    private var datablock : ((RMEpisodeDataReader) -> Void)?
    
    private var episode : RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            datablock?(model)
         
        }
    }
    init(episodeDataUrl : URL?) {
        
        self.episodeDataUrl = episodeDataUrl
    }
    public func registerForData(_ block : @escaping(RMEpisodeDataReader) -> Void ){
        self.datablock = block
    }
    public func fetchEpisode(){
        guard !isfetching else {
            if let model = episode {
                self.datablock?(model)
            }
            return
        }
        guard let url = episodeDataUrl,let request = RMRequest(url: url) else {
            return
        }
        isfetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.episode = model
                DispatchQueue.main.async {
                    self?.episode = model
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
