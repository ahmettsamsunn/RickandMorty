//
//  RMFooterLoadingCollectionReusableView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 1.07.2023.
//

import UIKit

class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView (style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
        static let identifier = "RMFooterLoadingCollectionReusableView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        layer.cornerRadius = 10
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        
    }
    public func startAnimating(){
        spinner.startAnimating()
    }
}
