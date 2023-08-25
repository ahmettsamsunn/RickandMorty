//
//  SettingsViewController.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 28.06.2023.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

class SettingsViewController: UIViewController {
    
    private var settingsView : UIHostingController<RMSettingsView>?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        addSwiftUIController()
        // Do any additional setup after loading the view.
    }
    private func addSwiftUIController(){
        let settingsView = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                self.handleTap(option: option)
            }
        }))))
        addChild(settingsView)
        settingsView.didMove(toParent: self)
        view.addSubview(settingsView.view)
        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingsView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            settingsView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.settingsView = settingsView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func handleTap(option  : RMSettingsOption) {
        if let url = option.targerURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }else if option == .rateApp {
            if let windowscene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowscene )
            }
        }
    }
}
