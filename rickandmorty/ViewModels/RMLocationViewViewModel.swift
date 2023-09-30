//
//  RMLocationViewViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 22.07.2023.
//

import Foundation
protocol RMLocationViewViewModelDelegate : AnyObject {
    func didFetchInitialLocations()
}
final class RMLocationViewViewModel {
    weak var delegate : RMLocationViewViewModelDelegate?
    
    private var locations :[RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel){
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    
    private var apiInfo : RMGetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels : [RMLocationTableViewCellViewModel] = []
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    public var isloadingmore = false
    private var didFinishPagination : (()  -> Void)?
    
    init(){ }
    public func registerDidFinishingPagination(_ block: @escaping () -> Void){
        self.didFinishPagination = block
    }
  
    public func fetchAdditionalLocations(){
        
        guard !isloadingmore else {
            return
        }
        guard let nexurlstring = apiInfo?.next,
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
          
                self?.apiInfo = info
                self?.cellViewModels.append(contentsOf: Moreresults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    self?.isloadingmore = false
                    self?.didFinishPagination?()
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isloadingmore = false
            }
        }
    }
   
    
    public func location(at index : Int) -> RMLocation? {
        guard index < locations.count,index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    public func fetchLocations(){
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.apiInfo = success.info
                self?.locations = success.results
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(_): break
                break
            }
        }
    }
    private var hasMoreResults : Bool {
        return false
    }
}
