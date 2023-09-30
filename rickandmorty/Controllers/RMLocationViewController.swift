//
//  RMLocationViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import UIKit

class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {

    
    
private let primaryView = RMLocationView()
    private let viewmodel = RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Locations"
        view.addSubview(primaryView)
        addconstraints()
        addsearchbutton()
        primaryView.delegate = self
        viewmodel.delegate = self
        viewmodel.fetchLocations()
        
        // Do any additional setup after loading the view.
    }
    private func addsearchbutton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        
    }
    @objc private func didTapSearch(){
        let vc = RMSearchViewController(config: .init(type: .location))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addconstraints(){
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
         let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewmodel)
    }
}
