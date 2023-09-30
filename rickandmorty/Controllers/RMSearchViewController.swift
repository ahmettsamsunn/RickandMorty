//
//  RMSearchViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 13.07.2023.
//

import UIKit

class RMSearchViewController: UIViewController {
    struct Config {
        enum `Type`{
            
            case character
            //name status gender
            case episode
            //name
            case location
            // name and type
            
            var endPoint : RMEndPoint {
                switch self {
                case .character : return .character
                case .episode: return .episode
                case .location : return .location
                }
            }
           
            var title : String {
                switch self {
                case .character:
                    return "Karakter Ara"
                case .episode:
                    return "Bölüm Ara"
                case .location:
                    return "Lokasyon ara"
                }
            }
        }
        let type : `Type`
        
    }
    private let searchView : RMSearchView
    private let config : Config
    private let viewModel : RMSearchViewViewModel
    init(config : Config){
        self.config = config
       
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.addSubview(searchView)
        addconstraints()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ara", style: .done, target: self, action: #selector(didTapExecuteSearch))
        searchView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }
    @objc
    private func didTapExecuteSearch(){
        viewModel.executeSearch()
    }
    private func addconstraints(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    

}
extension RMSearchViewController : RMSearchViewDelegate {
  
    
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSerachInputViewViewModel.DynamicOption) {
        
       
        let vc  = RMSearchOptionPickerViewController(option: option) { selection in
         
            DispatchQueue.main.async {
                self.viewModel.set(value: selection, for: option)

            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
        
    }
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        navigationController?.pushViewController(vc, animated: true)
    }
  
    
    
}
