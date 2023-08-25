//
//  RMLocationDetailViewViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 25.08.2023.
//

import Foundation
protocol RMLocationDetailViewViewModelDelegate : AnyObject {
    func didFetchLocationDetails()
}
final class RMLocationDetailViewViewModel {
    
    
    private let endpointURL : URL?
    private var datatuple : (location : RMLocation,characters :[RMCharacter])? {
        didSet {
            creacteCellViewModel()
            delegate?.didFetchLocationDetails()
        }
    }
    enum SectionType {
        case information(viewModel : [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel : [RMCharactersCollectionViewCellViewModel])
    }
    
    
    
    public weak var delegate : RMLocationDetailViewViewModelDelegate?
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
        let location = datatuple.location
        let characters = datatuple.characters
        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateformatter.date(from: location.created ?? "") {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortdateformatter.string(from: date)
        }
        sections = [
        
            .information(viewModel: [.init(title: "Location Name", value: location.name),
                                     .init(title: "Type", value: location.type),
                                     .init(title: "Dimension", value: location.dimension),
                                     .init(title: "Created", value: createdString ?? "")]),
            .characters(viewModel: characters.compactMap({
                return RMCharactersCollectionViewCellViewModel(charactername: $0.species, characterStatusText: $0.status, characterimageurl: URL(string: $0.image))
            }))
            
        ]
        
    }
    public func fetchLocationData(){
        guard let url = endpointURL ,let request = RMRequest(url: url) else {
            return
            
        }
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.fetchReleatedCharacters(location: success)
            case .failure(_):
                print("error")
                break
            }
        }
    }
    private func fetchReleatedCharacters(location : RMLocation){
        let requests : [RMRequest] = location.residents.compactMap({
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
            ( location : location,
              characters : characters)
        }
    }
   
}
