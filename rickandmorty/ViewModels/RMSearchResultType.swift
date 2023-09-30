//
//  RMSearchResultViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 25.09.2023.
//

import Foundation

final class RMSearchResultViewModel {
    public private(set) var results : RMSearchResultType
    var next: String?
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    public private(set) var isloadingmore = false
    public var shouldShowLoadMoreIndicator : Bool {
        return next != nil
    }
    
    public func fetchAdditionalResults(completion:@escaping ([any Hashable]) -> Void){
        guard !isloadingmore else {
            return
        }
        guard let nexurlstring = next,
              let url = URL(string:nexurlstring) else {
            return
        }
        isloadingmore = true
       
        guard let request = RMRequest(url: url) else {
            isloadingmore = false
            print("failed to fln")
            return
        }
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
                switch result {
                case .success(let responsemodel):
                    let Moreresults = responsemodel.results
                    let info = responsemodel.info
              
                    self?.next = info.next
                    let additionalResults = Moreresults.compactMap({
                        return RMCharactersCollectionViewCellViewModel(charactername: $0.name, characterStatusText: $0.status, characterimageurl:URL(string: $0.image) )
                    })
                    var newResults : [RMCharactersCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                   self?.results = .characters(newResults)
                   
                    DispatchQueue.main.async {
                        self?.isloadingmore = false
                        completion(newResults)
                    }
                    
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isloadingmore = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
                switch result {
                case .success(let responsemodel):
                    let Moreresults = responsemodel.results
                    let info = responsemodel.info
              
                    self?.next = info.next
                    let additionalLocations = Moreresults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults : [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalLocations
                   self?.results = .episodes(newResults)
                   
                    DispatchQueue.main.async {
                        self?.isloadingmore = false
                        completion(newResults)
                    }
                    
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isloadingmore = false
                }
            }
        case .locations:
            break
        }
  
    }
    public func fetchAdditionalLocations(completion:@escaping ([RMLocationTableViewCellViewModel]) -> Void){
        guard !isloadingmore else {
            return
        }
        guard let nexurlstring = next,
              let url = URL(string:nexurlstring) else {
            return
        }
        isloadingmore = true
       
        guard let request = RMRequest(url: url) else {
            isloadingmore = false
            print("failed to fln")
            return
        }
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            switch result {
            case .success(let responsemodel):
                let Moreresults = responsemodel.results
                let info = responsemodel.info
          
                self?.next = info.next
                let additionalLocations = Moreresults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults : [RMLocationTableViewCellViewModel] = []
                switch self?.results {
                case .locations(let existingResults):
                     newResults = existingResults + additionalLocations
                    self?.results = .locations(newResults)
                    break
                case .characters, .episodes:
                    break
                case .none:
                    break
                }
               
                DispatchQueue.main.async {
                    self?.isloadingmore = false
                    completion(newResults)
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isloadingmore = false
            }
        }
    }
}

enum RMSearchResultType {
    case characters([RMCharactersCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
 
