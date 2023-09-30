//
//  ViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 23.06.2023.
//

import UIKit

class RMTabViewController:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
        // Do any additional setup after loading the view.
    }
    func setupTabs(){
        let charactersVC = RMCharacterViewController()
        let locaitonVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = SettingsViewController()
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locaitonVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image:UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Epidodes", image:UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        for nav in [nav1,nav2,nav3,nav4]{
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers([
        nav1,nav2,nav3,nav4
        ], animated: true)
    }


}

