//
//  RMCharactersCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 30.06.2023.
//

import UIKit

class RMCharactersCollectionViewCell: UICollectionViewCell {
   
    static let celldenifier = "RMCharactersCollectionViewCell"
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true  
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let namelabel : UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = .label
        namelabel.font = UIFont.systemFont(ofSize: 15)
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        return namelabel
    }()
    private let statuslabel : UILabel = {
        let statuslabel = UILabel()
        statuslabel.textColor = .secondaryLabel
        statuslabel.font = UIFont.systemFont(ofSize: 15)
        statuslabel.translatesAutoresizingMaskIntoConstraints = false
        return statuslabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowOpacity = 0.4
        contentView.addSubview(imageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(statuslabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            statuslabel.heightAnchor.constraint(equalToConstant: 40),
            statuslabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            statuslabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -5),
            statuslabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            namelabel.heightAnchor.constraint(equalToConstant: 40),
            namelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            namelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -5),
            namelabel.bottomAnchor.constraint(equalTo: statuslabel.topAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
           imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor ),
           imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
           imageView.bottomAnchor.constraint(equalTo: namelabel.topAnchor,constant: -4),
            
            
            
        ])
        

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        namelabel.text = nil
        statuslabel.text = nil
        imageView.image = nil
    }
    public func configure(with viewModel : RMCharactersCollectionViewCellViewModel){
        namelabel.text = viewModel.charactername
        statuslabel.text = viewModel.CharacterStatusText
        viewModel.fetchimages { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
