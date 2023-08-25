//
//  RMEpisodeListViewVİewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 11.07.2023.
//


import Foundation
import UIKit
protocol RMEpisodeListViewViewModelDelegate : NSObject {
    func didloadinitialepisodes()
    func didloadmoreepisodes(with newIndexPath : [IndexPath])
    func didselectepisode(_ episode : RMEpisode)
}
final class RMEpisodeListViewViewModel : NSObject {
    weak public var delegate : RMEpisodeListViewViewModelDelegate?
    private var episodes : [RMEpisode] = [] {
        didSet {
            
            for episode in episodes{
                let viewmodel = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
                if !cellsviewmodel.contains(viewmodel){
                    cellsviewmodel.append(viewmodel)
                }
                
            }
            
        }
    }
    
    private var cellsviewmodel : [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var responseinfo : RMGetAllEpisodesResponse.Info? = nil
    func fetchEpisodes(){
        RMService.shared.execute(.listEpisodesRequest , expecting: RMGetAllEpisodesResponse.self){[weak self] result in
            switch result {
            case .success(let model):
                let results = model.results
                let info = model.info
                self?.responseinfo = info
                self?.episodes = results
                DispatchQueue.main.async {
                    self?.delegate?.didloadinitialepisodes()
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
    public func fetchAdditionalEpisodes(url : URL){
        
        guard !isloadingmore else {
            return
        }
        
        isloadingmore = true
        
        guard let request = RMRequest(url: url) else {
            isloadingmore = false
            print("failed to fln")
            return
        }
        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            switch result {
            case .success(let responsemodel):
                let Moreresults = responsemodel.results
                let info = responsemodel.info
                self?.responseinfo = info
                
                let originalCount = self?.episodes.count
                
                let newcount = Moreresults.count
                
                let total = (originalCount ?? 0) + newcount
                
                let startingindex = total - newcount
                
                let indexpathstoadd : [IndexPath] = Array(startingindex..<(startingindex + newcount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                self?.episodes.append(contentsOf: Moreresults)
                DispatchQueue.main.async {
                    self?.delegate?.didloadmoreepisodes(with:indexpathstoadd)
                    self?.isloadingmore = false
                }
                
            case .failure(let failure):
                print(String(describing: failure))
                self?.isloadingmore = false
            }
        }
    }
    
}
extension RMEpisodeListViewViewModel :  UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsviewmodel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
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
        let width = (bounds.width - 20)
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didselectepisode(episode)
    }
    
}
extension RMEpisodeListViewViewModel : UIScrollViewDelegate {
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
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
