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
    init(){
        
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
            case .failure(let failure):
                print("başarısız")
            }
        }
    }
    private var hasMoreResults : Bool {
        return false
    }
}
