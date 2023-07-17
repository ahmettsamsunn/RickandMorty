//
//  RMCharacterDetailViewViewModel.swift
//  rickandmorty
//
//  Created by Ahmet Samsun on 1.07.2023.
//

import Foundation
import UIKit
final class RMCharacterDetailViewViewModel {
    private let character : RMCharacter
    public var episodes : [String] {
        character.episode
    }
    enum SectionType  {
        case photo(viewModel : RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModel : [RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModel : [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var section : [SectionType] = []
    init(character : RMCharacter){
        self.character = character
        setUpSections()
    }
    public var title : String {
        character.name.uppercased()
    }
    private var requestURL : URL? {
        return URL(string: character.url)
    }
    private func setUpSections(){
        section = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            
            .information(viewModel: [
                .init(type :.status ,value:character.status.text),
                .init(type :.gender ,value: character.gender.rawValue),
                .init(type :.type ,value: character.type),
                .init(type :.species ,value: character.species),
                .init(type : .origin ,value: character.origin.name),
                .init(type : .location,value: character.location.name),
                .init(type : .created,value: character.created),
                .init(type :.episodeCount ,value:"\(character.episode.count)"),
                
            ]),
            .episodes(viewModel: character.episode.compactMap ({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
            
        ]
    }
    public func CreatePhotoSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
       
            return section
    }
   public func CreateInformationSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
    
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitems: [item,item])
        
        let section = NSCollectionLayoutSection(group: group)
       
            return section
    }
   public func CreateEpisodesSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
       let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(150)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
       
            return section
    }
  
}
