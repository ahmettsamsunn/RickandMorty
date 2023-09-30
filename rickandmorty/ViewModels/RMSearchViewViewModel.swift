//
//  RMSerachViewViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.08.2023.
//

import Foundation
final class RMSearchViewViewModel {
    let config : RMSearchViewController.Config
    private var optionMap : [RMSerachInputViewViewModel.DynamicOption : String] = [:]
    private var searchText = ""
    private var optionMapUpdateBlock : (((RMSerachInputViewViewModel.DynamicOption,String))  -> Void)?
    private var searchResultHandler : ((RMSearchResultViewModel) -> Void)?
    private var noResultHandler : (() -> Void)?
    private var searchResultsModel : Codable?
    init(config : RMSearchViewController.Config ) {
        self.config = config
    }

    public func registerSearchResultsHandler(_ block : @escaping (RMSearchResultViewModel) -> Void){
        self.searchResultHandler = block
    }
    public func registernoResultsHandler(_ block : @escaping () -> Void){
        self.noResultHandler = block
    }
    public func executeSearch(){
       
        var queryParams : [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed  ))]
      
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _,element in
            let key : RMSerachInputViewViewModel.DynamicOption = element.key
            
          
            let value : String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        let request = RMRequest(endpoint: config.type.endPoint,queryparameters: queryParams)
        
        switch config.type.endPoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request )
        }
    
    
      
    }
    private func makeSearchAPICall<T: Codable>(_ type : T.Type,request : RMRequest){
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.proccesSearchResults(model: model)
            case .failure(_):
                self?.handleNoresults()
                break
            }
        }
    }
    private func proccesSearchResults(model : Codable){
        var resultsVM : RMSearchResultType?
        var nextUrl : String?
        if let characterResults = model as? RMGetAllCharactersResponse{
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharactersCollectionViewCellViewModel(charactername: $0.name, characterStatusText: $0.status, characterimageurl: URL(string: $0.image))
                
            }))
            nextUrl = characterResults.info.next
        }
        else if let EpisodeResults = model as? RMGetAllEpisodesResponse{
           
            resultsVM = .episodes(EpisodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = EpisodeResults.info.next
        }
        else if let LocationResults = model as? RMGetAllLocationsResponse{
            
            resultsVM = .locations(LocationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = LocationResults.info.next
        }
        if let results = resultsVM {
            self.searchResultsModel = model
            let vm = RMSearchResultViewModel(results: results,next: nextUrl)
            self.searchResultHandler?(vm)
        }else {
            handleNoresults()        }
    }
    private func handleNoresults(){
        noResultHandler?()
    }
    public func set(query text : String){
        self.searchText = text
    }
    public func set(value : String,for option : RMSerachInputViewViewModel.DynamicOption){

        optionMap[option] = value
        let tuple = (option,value)
        optionMapUpdateBlock?(tuple)
    }
    public func registerOptionsChangeBlock(_ block: @escaping ((RMSerachInputViewViewModel.DynamicOption,String )) -> Void) {
        self.optionMapUpdateBlock = block
    }
    public func locationSearchResults(at index : Int) -> RMLocation? {
        guard let searchmodel = searchResultsModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchmodel.results[index]
    }
}
