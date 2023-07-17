//
//  CharactersListView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 30.06.2023.
//

import UIKit
protocol CharactersListViewDelegate : AnyObject {
    func rmcharacterlistview(_ characterlistview : CharactersListView,didselectcharacters character:RMCharacter)
}
class CharactersListView: UIView {
    let viewModel = RMCharactersListViewModel()
   public weak var delegate : CharactersListViewDelegate?
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView (style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let collectionview : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(RMCharactersCollectionViewCell.self, forCellWithReuseIdentifier: RMCharactersCollectionViewCell.celldenifier)
        collectionview.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        collectionview.isHidden = true
        collectionview.alpha = 0
        return collectionview
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionview)
        addSubview(spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setUpCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    private func setUpCollectionView(){
        collectionview.dataSource = viewModel
        collectionview.delegate = viewModel
       
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension CharactersListView : RMCharactersListViewModelDelegate {
    func didloadmorecharacter(with newIndexPath: [IndexPath]) {
        collectionview.performBatchUpdates {
            self.collectionview.insertItems(at: newIndexPath)
        }
    }
    
    func didselectcharacters(_ character: RMCharacter) {
        delegate?.rmcharacterlistview(self, didselectcharacters: character)
    }
    
    func didloadinitialcharacters() {
        collectionview.reloadData()
        self.spinner.stopAnimating()
        self.collectionview.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionview.alpha = 1
            
        }
    }
    
    
}
