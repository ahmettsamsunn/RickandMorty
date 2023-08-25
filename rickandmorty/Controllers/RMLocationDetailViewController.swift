//
//  RMLocationDetailViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 23.08.2023.
//

import UIKit

class RMLocationDetailViewController: UIViewController ,RMLocationDetailViewViewModelDelegate,RMLocationDetailViewDelegate {
  
 
    
    
    
    
    private let viewmodel : RMLocationDetailViewViewModel
    private let detailview  = rickandmorty.RMLocationDetailView()
    
    init(location : RMLocation){
        let url = URL(string: location.url!)
        self.viewmodel = RMLocationDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.addSubview(detailview)
        addconstarints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        viewmodel.delegate = self
        detailview.delegate = self
        viewmodel.fetchLocationData ()
        
        // Do any additional setup after loading the view.
    }
    private func addconstarints(){
        
        NSLayoutConstraint.activate([
            detailview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailview.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailview.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    @objc private func didTapShare(){
        
    }
    func RMLocationDetailView(_ detailview: RMLocationDetailView , didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func didFetchLocationDetails() {
        detailview.configure(with: viewmodel)
    }
    
}
