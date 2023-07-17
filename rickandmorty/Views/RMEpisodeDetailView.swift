//
//  RMEpisodeDetailView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 10.07.2023.
//

import UIKit
protocol RMEpisodeDetailViewDelegate : AnyObject {
    func rmEpisodeDetailView(_ detailview: RMEpisodeDetailView , didSelect character : RMCharacter )
}
class RMEpisodeDetailView: UIView {
    
    public weak var delegate : RMEpisodeDetailViewDelegate?
    
    private var collectionView : UICollectionView!
    private let spinnder : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private var viewModel : RMEpisodeDetailViewViewModel? {
        didSet {
            spinnder.stopAnimating()
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = createCollectionView()
        addSubview(collectionView)
        addSubview(spinnder)
        addconstraints()
        spinnder.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func addconstraints(){
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinnder.heightAnchor.constraint(equalToConstant: 100),
            spinnder.widthAnchor.constraint(equalToConstant: 100),
            spinnder.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinnder.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            
        
        ])
    }
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for:section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.indentifier)
        collectionView.register(RMCharactersCollectionViewCell.self, forCellWithReuseIdentifier: RMCharactersCollectionViewCell.celldenifier)
        return collectionView
    }
    public func configure(with viewModel : RMEpisodeDetailViewViewModel){
        self.viewModel = viewModel
    }
}
extension RMEpisodeDetailView : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.sections else {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModel):
            return viewModel.count
        case .characters(let viewModel):
            return viewModel.count
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.sections else {
            fatalError("Fatal Error")        }
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMEpisodeInfoCollectionViewCell.indentifier , for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
       
            return cell
        case .characters(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMCharactersCollectionViewCell.celldenifier , for: indexPath) as? RMCharactersCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {
            return
        }
        let section = viewModel.sections
        let sectionType = section[indexPath.section]
           
        
        switch sectionType {
        case .information:
            break
        case .characters:
            guard  let character = viewModel.character(at : indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
        
    }
}
extension RMEpisodeDetailView {
    func layout(for section : Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.sections else {
            return createinfolayout()
        }
        switch sections[section] {
        case .information:
             return createinfolayout()
        default:
            return createcharacterlayout()
        }
    }
    func createcharacterlayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
    
        item.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 9, bottom: 9, trailing: 9)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)), subitems: [item,item])
        
        let section = NSCollectionLayoutSection(group: group)
       
            return section
    }
    func createinfolayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
    
        return section
    }
}
