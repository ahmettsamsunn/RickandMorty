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
            case episode
            case location
        }
        let type : `Type`
        
    }
    private let config : Config
    init(config : Config){
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .secondarySystemBackground
        // Do any additional setup after loading the view.
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
