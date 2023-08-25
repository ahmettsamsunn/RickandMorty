//
//  RMCharactersViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 30.06.2023.
//

import Foundation
import UIKit
protocol RMCharactersListViewModelDelegate : NSObject {
    func didloadinitialcharacters()
    func didloadmorecharacter(with newIndexPath : [IndexPath])
    func didselectcharacters(_ character : RMCharacter)
}
final class RMCharactersListViewModel : NSObject {
    weak public var delegate : RMCharactersListViewModelDelegate?
    private var characters : [RMCharacter] = [] {
        didSet {
            
            for character in characters {
                let viewmodel = RMCharactersCollectionViewCellViewModel(charactername: character.name, characterStatusText: character.status, characterimageurl: URL(string: character.image))
                if !cellsviewmodel.contains(viewmodel){
                    cellsviewmodel.append(viewmodel)
                }
                
            }
            
        }
    }
    
    private var cellsviewmodel : [RMCharactersCollectionViewCellViewModel] = []
    private var responseinfo : RMGetAllCharactersResponse.Info? = nil
    func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self){[weak self] result in
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                self?.responseinfo = info
                self?.characters = results
                DispatchQueue.main.async {
                    self?.delegate?.didloadinitialcharacters()
                }
                
            case .failure(let error):
                print(String(describing: error))
                print("error")
            }
        }
    }
    public var isloadingmore : Bool = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return responseinfo?.next != nil
    }
    public func fetchAdditionalCharacters(url : URL){
        
        guard !isloadingmore else {
            return
        }
        
        isloadingmore = true
        
        guard let request = RMRequest(url: url) else {
            isloadingmore = false
            print("failed to fln")
            return
        }
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result {
            case .success(let responsemodel):
                let Moreresults = responsemodel.results
                let info = responsemodel.info
                self?.responseinfo = info
                
                let originalCount = self?.characters.count
                
                let newcount = Moreresults.count
                
                let total = (originalCount ?? 0) + newcount
                
                let startingindex = total - newcount
                
                let indexpathstoadd : [IndexPath] = Array(startingindex..<(startingindex + newcount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self?.characters.append(contentsOf: Moreresults)
                DispatchQueue.main.async {
                    self?.delegate?.didloadmorecharacter(with:indexpathstoadd)
                    self?.isloadingmore = false
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isloadingmore = false
            }
        }
    }
    
}
extension RMCharactersListViewModel :  UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharactersCollectionViewCell.celldenifier, for: indexPath) as? RMCharactersCollectionViewCell else {
            fatalError("olmadı bu cell ")
        }
        if indexPath.row < cellsviewmodel.count {
            let viewModel = cellsviewmodel[indexPath.row]
            cell.configure(with: viewModel)
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("error124555")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("error")
        }
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didselectcharacters(character)
    }
    
}
extension RMCharactersListViewModel : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isloadingmore, let nexurlstring = responseinfo?.next,
              let url = URL(string:nexurlstring),!cellsviewmodel.isEmpty
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight ){
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
