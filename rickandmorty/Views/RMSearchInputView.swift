//
//  RMSearchInputView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 1.09.2023.
//

import UIKit
protocol RMSearchInputViewDelegate : AnyObject {
    func rmSearchInputView(_ inputView : RMSearchInputView , didSelectOption option : RMSerachInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView : RMSearchInputView , didChangeSearchText text : String)
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView : RMSearchInputView)
}
class RMSearchInputView: UIView {
    weak var delegate : RMSearchInputViewDelegate?
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Arama yapın"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private var viewModel : RMSerachInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel,viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    private var stackView : UIStackView?
    override init(frame: CGRect) {
        super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        addconstraints()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addconstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor,constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    private func  createOptionsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.alignment = .center
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
       return stackView
    }
    private func createOptionSelectionViews(options : [RMSerachInputViewViewModel.DynamicOption]){
        let stackView = createOptionsStackView()
        self.stackView = stackView
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with : option,tag : x)
            stackView.addArrangedSubview(button)

            print(option.rawValue)
        }
    }
    private func createButton(with option : RMSerachInputViewViewModel.DynamicOption,tag : Int) -> UIButton{
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: option.rawValue,attributes: [
            .font
            :UIFont.systemFont(ofSize: 18, weight: .medium),.foregroundColor : UIColor.label
        ]), for: .normal)
        button.setTitle(option.rawValue, for: .normal)
        button.backgroundColor = .secondarySystemGroupedBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
                button.tag = tag
        return button
    }

    @objc
    private func didTapButton(_ sender : UIButton){
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        print(selected)
        delegate?.rmSearchInputView(self, didSelectOption: selected)

        
    }
    public func configure(with viewModel : RMSerachInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }
    public func presentKeyboard(){
        
        searchBar.becomeFirstResponder()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public func update(option : RMSerachInputViewViewModel.DynamicOption,value : String ){
        guard let buttons = stackView?.arrangedSubviews as? [UIButton], let allOptions = viewModel?.options,let index = allOptions.firstIndex(of: option) else {
            
            return
        }
        let button : UIButton = buttons[index]
        
        button.setAttributedTitle(NSAttributedString(string: value.uppercased(),attributes: [
            .font
            :UIFont.systemFont(ofSize: 18, weight: .medium),.foregroundColor : UIColor.link
        ]), for: .normal)

    }
}
extension RMSearchInputView : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self  )
    }
}
