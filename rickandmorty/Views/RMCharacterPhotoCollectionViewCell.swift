//
//  RMCharacterPhotoCollectionViewCell.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 4.07.2023.
//

import UIKit

class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    static let identifier = "RMCharacterPhotoCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),])

    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    public func configure(with viewModel : RMCharacterPhotoCollectionViewCellViewModel ) {
        viewModel.fetchImage { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: success)
                }
               
            case .failure(_):
                break
            }
        }
        
    }

    
}
