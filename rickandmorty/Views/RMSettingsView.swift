//
//  RMSettingsView.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 17.07.2023.
//

import SwiftUI

struct RMSettingsView: View {
    private let viewModel : RMSettingsViewViewModel
    init(viewModel : RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
  
    var body: some View {
       
            
            List(viewModel.cellViewModels) { viewModel in
                HStack {
                    if let image = viewModel.image {
                       Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30,height: 30)
                            .padding(8)
                            
                            .background(Color(viewModel.iconContainerColor))
                            .cornerRadius(6)
                            
                        Spacer()
                    }
                
                    Text(viewModel.title)
                    .padding(.leading,5)
                    .onTapGesture {
                        viewModel.onTapHandler(viewModel.type )
                    }
                        
                }
                
            }
    
        
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
               
            }
        })))
    }
}
