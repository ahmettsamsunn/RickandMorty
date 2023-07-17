//
//  RMCharacterInfoCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    private let valuelabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    private let titlelabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private let iconimageview :UIImageView = {
       let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false

        return icon
    }()
    private let titlecontainerview :UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemFill
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        contentView.addSubview(titlecontainerview)
        titlecontainerview.addSubview(titlelabel)
        contentView.addSubview(valuelabel)
        
        
        contentView.addSubview(iconimageview)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            titlecontainerview.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titlecontainerview.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titlecontainerview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titlecontainerview.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            titlelabel.topAnchor.constraint(equalTo: titlecontainerview.topAnchor),
            titlelabel.bottomAnchor.constraint(equalTo: titlecontainerview.bottomAnchor),
            titlelabel.leftAnchor.constraint(equalTo: titlecontainerview.leftAnchor),
            titlelabel.rightAnchor.constraint(equalTo: titlecontainerview.rightAnchor),
           
            iconimageview.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            iconimageview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            iconimageview.heightAnchor.constraint(equalToConstant: 30),
            iconimageview.widthAnchor.constraint(equalToConstant: 30),
            valuelabel.leftAnchor.constraint(equalTo: iconimageview.rightAnchor, constant: 10),
            valuelabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            valuelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            valuelabel.bottomAnchor.constraint(equalTo: titlecontainerview.topAnchor),
           
            
           
            
        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titlelabel.text = nil
        valuelabel.text = nil
        iconimageview.image = nil
        iconimageview.tintColor = nil
    }
    public func configure(with viewModel : RMCharacterInfoCollectionViewCellViewModel ) {
        titlelabel.text = viewModel.title
        valuelabel.text = viewModel.displayValue
        iconimageview.image = viewModel.iconImage
   
        
    }
}
