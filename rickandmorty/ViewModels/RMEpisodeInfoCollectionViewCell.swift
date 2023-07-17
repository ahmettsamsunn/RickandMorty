//
//  RMEpisodeInfoCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 15.07.2023.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let indentifier = "RMEpisodeInfoCollectionViewCell"
    private let titlelabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let valuelabel : UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.addSubview(titlelabel)
        contentView.addSubview(valuelabel)
        addconstraints()
        setuplayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titlelabel.text = nil
        valuelabel.text = nil
    }
    private func setuplayer(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = .init(red: 49/255, green: 139/255, blue: 190/255, alpha: 1)
    }
    private func addconstraints(){
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
            titlelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            titlelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            valuelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valuelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            valuelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titlelabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            titlelabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
        ])
    }
    func configure(with viewModel : RMEpisodeInfoCollectionViewCellViewModel){
        titlelabel.text = viewModel.title
        valuelabel.text = viewModel.value
    }
}
