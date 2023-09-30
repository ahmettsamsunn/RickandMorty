//
//  RMSearchView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.08.2023.
//

import UIKit
protocol RMSearchViewDelegate : AnyObject {
    func rmSearchView(_ searchView : RMSearchView , didSelectOption option : RMSerachInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView : RMSearchView , didSelectLocation location :RMLocation)
}

class RMSearchView: UIView {
    weak var delegate : RMSearchViewDelegate?
    private let searchinputView = RMSearchInputView()
    
    private let viewModel : RMSearchViewViewModel
    private let noResultView = RMNoSeachResultsView()
    private let resultsView = RMSearchResultsView ()
    
     init(frame: CGRect,viewModel : RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
         translatesAutoresizingMaskIntoConstraints = false
         addSubview(noResultView)
         addSubview(resultsView)
         addSubview(searchinputView)
         addConstraints()
         searchinputView.configure(with: RMSerachInputViewViewModel(type: viewModel.config.type))
         searchinputView.delegate = self
         resultsView.delegate = self
         setUpHandler(viewModel : viewModel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func presentKeyboard(){
        searchinputView.presentKeyboard()
    }
    private func setUpHandler(viewModel :RMSearchViewViewModel) {
        viewModel.registerOptionsChangeBlock { tuple in
            
            print(String(describing: tuple))
            self.searchinputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultsHandler { [weak self]  results in
            
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        viewModel.registernoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }

    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            searchinputView.topAnchor.constraint(equalTo: topAnchor),
            searchinputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchinputView.rightAnchor.constraint(equalTo:rightAnchor),
            searchinputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.topAnchor.constraint(equalTo: searchinputView.bottomAnchor),
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
extension RMSearchView : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}
extension RMSearchView : RMSearchInputViewDelegate {
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSerachInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
       
    }
    
    
}
extension RMSearchView : RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTap index: Int) {
        
        guard let locationModel = viewModel.locationSearchResults(at : index) else {
            return
        }
      
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    
    
}
