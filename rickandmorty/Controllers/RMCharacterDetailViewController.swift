//
//  RMCharacterDetailViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 1.07.2023.
//

import UIKit

class RMCharacterDetailViewController: UIViewController {
    private let viewmodel : RMCharacterDetailViewViewModel
    private let detailview : RMCharacterDetailView
    init(viewModel : RMCharacterDetailViewViewModel )
    {
        self.viewmodel = viewModel
        self.detailview = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewmodel.title
        view.addSubview(detailview)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
     
        addConstraints()
        detailview.collectionView?.delegate = self
        detailview.collectionView?.dataSource = self
        // Do any additional setup after loading the view.
    }
    @objc func didTapShare(){
        
    }
    func addConstraints() {
        NSLayoutConstraint.activate([
           detailview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           detailview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           detailview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           detailview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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

}
extension RMCharacterDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewmodel.section.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectiontype = viewmodel.section[section]
        switch sectiontype {
        case .photo:
            return 1
        case .episodes(let viewModel):
            return viewModel.count
        case .information(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectiontype = viewmodel.section[indexPath.section]
        switch sectiontype {
        case .photo(let viewModel):
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                fatalError()
            }
            cell.backgroundColor = .systemPink
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.configure(with: viewModel)
            return cell
        case .episodes(let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                 fatalError()
             }
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.backgroundColor = .green
            let viewmodel = viewModel[indexPath.row]
           
            cell.configure(with: viewmodel)
            return cell
        case .information(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                 fatalError()
             }
            cell.configure(with: viewModel[indexPath.row])
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.backgroundColor = .orange
            return cell
        }
        
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectiontype = viewmodel.section[indexPath.section]
        switch sectiontype {
        case .photo,.information :
            break
            
        case .episodes(_):
            
            let episodes = self.viewmodel.episodes
            let selection = episodes[indexPath.row]
            let vc = RMEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
           
             
        
        }
    }
    
}
