//
//  RMCharacterDetailView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 1.07.2023.
//

import UIKit

class RMCharacterDetailView: UIView {
    private var viewModel : RMCharacterDetailViewViewModel
  public var collectionView : UICollectionView?
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView (style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
init(frame: CGRect,viewModel : RMCharacterDetailViewViewModel) {
    self.viewModel = viewModel
        super.init(frame: frame)
    backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        let collectionview = createCollectionView()
        self.collectionView = collectionview
        addSubview(collectionview)
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints(){
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionindex, _ in
            return self.createSection(for: sectionindex)
        }
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(RMCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier)
        collectionview.register(RMCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier)
        collectionview.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func createSection(for sectionindex : Int) -> NSCollectionLayoutSection{
        let sectionTypes = viewModel.section
        switch sectionTypes[sectionindex] {
        case .photo:
            return  viewModel.CreatePhotoSectionLayout()
        case .information:
            return  viewModel.CreateInformationSectionLayout()
        case .episodes:
            return  viewModel.CreateEpisodesSectionLayout()
        
            
        }
        
      
        
    }

}
