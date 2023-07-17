//
//  RMCharacterEpisodeCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterEpisodeCollectionViewCell"
    private let episodelabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let namelabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
       
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.addSubview(namelabel)
        contentView.addSubview(episodelabel)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = .init(red: 49/255, green: 139/255, blue: 190/255, alpha: 1)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            namelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            namelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            namelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            episodelabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 10),
            episodelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            episodelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            
        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        namelabel.text = nil
        episodelabel.text = nil
    }
    public func configure(with viewModel : RMCharacterEpisodeCollectionViewCellViewModel ) {
        viewModel.registerForData { [weak self] data in
            DispatchQueue.main.async {
                self?.namelabel.text =  data.name
                
                self?.episodelabel.text = "Episode" + " " + data.episode
            }
           
            
        }
        viewModel.fetchEpisode()
    }

}
