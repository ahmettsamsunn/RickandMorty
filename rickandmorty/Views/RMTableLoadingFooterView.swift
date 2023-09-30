//
//  RMTableLoadingFooterView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 29.09.2023.
//

import UIKit

final class RMTableLoadingFooterView: UIView {


    private let spinnder : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(spinnder)
        spinnder.startAnimating()
        addconstraints()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addconstraints(){
        NSLayoutConstraint.activate([
            spinnder.widthAnchor.constraint(equalToConstant: 55),
            spinnder.heightAnchor.constraint(equalToConstant: 55),
            spinnder.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnder.centerYAnchor.constraint(equalTo: centerYAnchor),
            
         
        ])
    }
}
