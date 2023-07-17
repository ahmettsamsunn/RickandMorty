//
//  RMCharacterViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import UIKit

class RMCharacterViewController: UIViewController, CharactersListViewDelegate {
   
    
let charactersListView = CharactersListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
   
        setupView()
       addsearchbutton()
        
       
        
        // Do any additional setup after loading the view.
    }
    private func addsearchbutton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        
    }
    @objc private func didTapSearch(){
        
        let vc = RMSearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    private func setupView(){
        charactersListView.delegate = self
        view.addSubview(charactersListView)
        NSLayoutConstraint.activate([
            charactersListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            charactersListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            charactersListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    func rmcharacterlistview(_ characterlistview: CharactersListView, didselectcharacters character: RMCharacter) {
        let viewmodel = RMCharacterDetailViewViewModel(character: character)
         let detailVC = RMCharacterDetailViewController(viewModel: viewmodel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
