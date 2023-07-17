//
//  RMEpisodeDetailViewViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 10.07.2023.
//

import Foundation
protocol RMEpisodeDetailViewViewModelDelegate : AnyObject {
    func didFetchEpisodeDetails()
}
final class RMEpisodeDetailViewViewModel {
    
    
    private let endpointURL : URL?
    private var datatuple : (episode : RMEpisode,characters :[RMCharacter])? {
        didSet {
            creacteCellViewModel()
            delegate?.didFetchEpisodeDetails()
        }
    }
    enum SectionType {
        case information(viewModel : [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel : [RMCharactersCollectionViewCellViewModel])
    }
    
    
    
    public weak var delegate : RMEpisodeDetailViewViewModelDelegate?
    public private(set) var sections : [SectionType] = []
    init(endpointURL : URL?) {
        self.endpointURL = endpointURL
        
    }
    public func character(at index : Int) -> RMCharacter?{
        guard let datatuple = datatuple else {
            return nil        }
        return datatuple.characters[index]
        
    }
    private func creacteCellViewModel(){
        guard let datatuple = datatuple else {
            return
        }
        let episode = datatuple.episode
        let characters = datatuple.characters
        var createdString = episode.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateformatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortdateformatter.string(from: date)
        }
        sections = [
        
            .information(viewModel: [.init(title: "Episode Name", value: episode.name),
                                     .init(title: "Air Date", value: episode.air_date),
                                     .init(title: "Episode", value: episode.episode),
                                     .init(title: "Created", value: createdString)]),
            .characters(viewModel: characters.compactMap({
                return RMCharactersCollectionViewCellViewModel(charactername: $0.species, characterStatusText: $0.status, characterimageurl: URL(string: $0.image))
            }))
            
        ]
        
    }
    public func fetchepisodeData(){
        guard let url = endpointURL ,let request = RMRequest(url: url) else {
            return
            
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.fetchReleatedCharacters(episode: success)
            case .failure(_):
                print("error")
                break
            }
        }
    }
    private func fetchReleatedCharacters(episode : RMEpisode){
        let requests : [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        let group = DispatchGroup()
        var characters : [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let success):
                    characters.append(success)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.datatuple =
            ( episode : episode,
              characters : characters)
        }
    }
   
}
