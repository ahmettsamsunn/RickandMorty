//
//  RMEpisodeDetailViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 7.07.2023.
//

import UIKit

class RMEpisodeDetailViewController: UIViewController,RMEpisodeDetailViewViewModelDelegate,RMEpisodeDetailViewDelegate {
    
    
    
    
    private let viewmodel : RMEpisodeDetailViewViewModel
    private let detailview  = RMEpisodeDetailView()

    
    init(url : URL?){
        self.viewmodel = RMEpisodeDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.addSubview(detailview)
        
        addconstarints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        viewmodel.delegate = self
        detailview.delegate = self
        viewmodel.fetchepisodeData()
        
        // Do any additional setup after loading the view.
    }
    private func addconstarints(){
        
        NSLayoutConstraint.activate([
            detailview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailview.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailview.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ])
    }
    @objc private func didTapShare(){
        
    }
    func rmEpisodeDetailView(_ detailview: RMEpisodeDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func didFetchEpisodeDetails() {
        detailview.configure(with: viewmodel)
    }
    
}
