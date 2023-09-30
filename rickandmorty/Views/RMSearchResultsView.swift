//
//  RMSearchResultsView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 27.09.2023.
//

import UIKit
protocol RMSearchResultsViewDelegate : AnyObject {
    func rmSearchResultsView(_ resultsView : RMSearchResultsView,didTap index : Int)
}
class RMSearchResultsView: UIView {

    weak var delegate : RMSearchResultsViewDelegate?
    
    private var viewModel : RMSearchResultViewModel?{
        didSet {
            self.processViewModel()
        }
    }
    private var collectionViewCellViewModels : [any Hashable] = []
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellidentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let collectionview : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.isHidden = true
   
        collectionview.register(RMCharactersCollectionViewCell.self, forCellWithReuseIdentifier: RMCharactersCollectionViewCell.celldenifier)
        collectionview.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionview.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
     
        return collectionview
    }()
    private var locationCellViewModels : [RMLocationTableViewCellViewModel] = []
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        addSubview(tableView)
        addSubview(collectionview)
        addconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addconstraints(){
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
           collectionview.topAnchor.constraint(equalTo:
                                                topAnchor),
           collectionview.leftAnchor.constraint(equalTo: leftAnchor),
           collectionview.rightAnchor.constraint(equalTo: rightAnchor),
           collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    private func processViewModel(){
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel.results    {
        case .characters(let array):
            self.collectionViewCellViewModels = array
            setUpCollectionView()
        case .episodes(let array):
            self.collectionViewCellViewModels = array
            setUpCollectionView()
        case .locations(let array):
            setUpTableView(viewModels : array)
        }
    }
    private func setUpCollectionView() {
        self.tableView.isHidden = true
        self.collectionview.isHidden = false
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.reloadData()
        
    }
    private func setUpTableView(viewModels : [RMLocationTableViewCellViewModel]){
       
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        self.locationCellViewModels = viewModels
       
        tableView.reloadData()
    }
    public func configure(with viewModel : RMSearchResultViewModel){
        self.viewModel = viewModel
    }
}
extension RMSearchResultsView : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellidentifier,for: indexPath) as? RMLocationTableViewCell else {
            fatalError("erroror")
        }
        cell.configure(with: locationCellViewModels[indexPath.row ])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        delegate?.rmSearchResultsView(self, didTap: indexPath.row)
    }

}
extension RMSearchResultsView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? RMCharactersCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharactersCollectionViewCell.celldenifier, for: indexPath) as? RMCharactersCollectionViewCell else {
                fatalError()
            }
           
                cell.configure(with: characterVM)
            
            return cell
        }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError()
            }
            if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
                cell.configure(with: episodeVM)
            }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        let bounds = UIScreen.main.bounds
        if currentViewModel is RMCharactersCollectionViewCellViewModel {
          
            let width = (bounds.width - 30)/2
            return CGSize(width: width, height: width * 1.5)
        }
       
        let width = (bounds.width - 20)
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("error124555")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("error")
        }
        if let viewModel = viewModel,viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }
        
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard  let viewmodel = viewModel,viewmodel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMSearchResultsView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty{
            handleLocationPagination(scrollView: scrollView)
        }else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
       
        
    }
    private func handleCharacterOrEpisodePagination(scrollView : UIScrollView){
        guard let viewmodel = viewModel,!collectionViewCellViewModels.isEmpty, !locationCellViewModels.isEmpty,viewmodel.shouldShowLoadMoreIndicator,!viewmodel.isloadingmore else {
            return
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                viewmodel.fetchAdditionalResults { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.collectionViewCellViewModels = newResults
                    print("new results \(newResults.count)")
                    
                }
              
            }
            t.invalidate()
        }
    }
    private func handleLocationPagination(scrollView : UIScrollView){
        guard let viewmodel = viewModel,!locationCellViewModels.isEmpty,viewmodel.shouldShowLoadMoreIndicator,!viewmodel.isloadingmore else {
            return
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight ){
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                viewmodel.fetchAdditionalLocations { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    print("new results1 \(newResults.count)")
                    self?.tableView.reloadData()
                }
              
            }
            t.invalidate()
        }
    }
    private func showLoadingIndicator(){
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}

