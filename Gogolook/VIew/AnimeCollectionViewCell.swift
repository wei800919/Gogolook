//
//  AnimeCollectionViewCell.swift
//  Gogolook
//
//  Created by 柯薇馨 on 2022/3/4.
//

import UIKit

class AnimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel = AnimeViewModel()
    let imageCache = NSCache<NSURL, UIImage>()
    
    func setup(top: TopCodable, index: Int ) {
        if let rank = top.rank, let title = top.title, let type = top.type {
            
            self.titleLabel.text = "\(rank). \(title)"
            self.typeLabel.text = type
            self.favoriteButton.tag = rank
            let favorites = viewModel.mainType == MainTypes.anime.rawValue ? viewModel.favorites : viewModel.mangaFavorites
            if favorites.contains(where: {$0 == rank}) {
                self.favoriteButton.isSelected = true
            }
            else {
                self.favoriteButton.isSelected = false
            }
        }
        
        let startDate = top.start_date == nil ? "--" : top.start_date!.stringFromDate( newFormatterString: "yyyy")
        let endDate = top.end_date == nil ? "--" : top.end_date!.stringFromDate( newFormatterString: "yyyy")
        self.dateLabel.text = "Aired: \(startDate) ~ \(endDate)"
        
        self.favoriteButton.setTitle("", for: .normal)
        self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.favoriteButton.backgroundColor = .clear
        self.favoriteButton.tintColor = UIColor(named: "CutomBackButtonTintColor")
        if let urlString = top.image_url {
            self.animeImageView.downloaded(from: urlString, cache: imageCache, contentMode: .scaleAspectFill)
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        button.isSelected = !button.isSelected
        var favorites = viewModel.mainType == MainTypes.anime.rawValue ? viewModel.favorites : viewModel.mangaFavorites
        if button.isSelected {
            favorites.append(button.tag)
        }
        else {
            if let index = favorites.firstIndex(where: { $0 == button.tag }) {
                favorites.remove(at: index)
            }
        }
        
        if viewModel.mainType == MainTypes.anime.rawValue {
            viewModel.favorites = favorites
            UserDefaults.standard.set(favorites, forKey: "favorites")
        }
        else {
            viewModel.mangaFavorites = favorites
            UserDefaults.standard.set(favorites, forKey: "mangaFavorites")
        }
    }
}
