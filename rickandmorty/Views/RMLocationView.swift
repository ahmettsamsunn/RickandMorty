//
//  RMLocationView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 22.07.2023.
//

import UIKit
protocol RMLocationViewDelegate : AnyObject {
    func rmLocationView(_ locationView:RMLocationView,didSelect location : RMLocation)
}
class RMLocationView: UIView {
   public weak var delegate : RMLocationViewDelegate?
    
 
    private var viewModel  : RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
          
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
            viewModel?.registerDidFinishingPagination { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellidentifier)
        table.alpha = 0
        table.isHidden = true
        return table
    }()
    private let spinner : UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView )
        addSubview(spinner)
       
        spinner.startAnimating()
        addconstraints()
        configuretable()
      
       
        
    }
    private func configuretable(){
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addconstraints(){
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
        ])
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public func configure(with viewModel :  RMLocationViewViewModel){
        self.viewModel = viewModel
            
    }
}
extension RMLocationView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel?.location(at: indexPath.row) else { return  }
        delegate?.rmLocationView(self, didSelect: viewModel)
    }
    
    
}
extension RMLocationView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.cellViewModels.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellviewModels = viewModel?.cellViewModels else {
            fatalError()
        }
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellidentifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        
        let cellViewmodel = cellviewModels[indexPath.row]
        
        cell.configure(with: cellViewmodel)
        
        return cell
    }
    
    
}
extension RMLocationView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let viewmodel = viewModel,!viewmodel.cellViewModels.isEmpty,
              viewmodel.shouldShowLoadMoreIndicator, !viewmodel.isloadingmore
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight ){
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                viewmodel.fetchAdditionalLocations()
              
            }
            t.invalidate()
        }
    }

    private func showLoadingIndicator(){
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}
