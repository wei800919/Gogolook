//
//  AnimeTableViewCell.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import UIKit

class AnimeTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel = AnimeViewModel()
    let imageCache = NSCache<NSURL, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(top: TopCodable, index: Int) {
        if let rank = top.rank, let title = top.title, let type = top.type {
            self.rankLabel.text = "\(rank)"
            self.titleLabel.text = title
            self.typeLabel.text = type
            self.favoriteButton.tag = rank
            if viewModel.favorites.contains(where: {$0 == rank}) {
                self.favoriteButton.isSelected = true
            }
            else {
                self.favoriteButton.isSelected = false
            }
        }
        self.startDateLabel.text = top.start_date == nil ? "N/A" : top.start_date!.stringFromDate( newFormatterString: "yyyy")
        self.endDateLabel.text = top.end_date == nil ? "N/A" : top.end_date!.stringFromDate( newFormatterString: "yyyy")
        
        self.favoriteButton.setTitle("", for: .normal)
        self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        self.favoriteButton.backgroundColor = .clear
        self.favoriteButton.tintColor = .white
        if let urlString = top.image_url {
            self.animeImageView.downloaded(from: urlString, cache: imageCache, contentMode: .scaleAspectFill)
        }
    }
    @IBAction func favoriteButtonAction(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        button.isSelected = !button.isSelected
        if button.isSelected {
            viewModel.favorites.append(button.tag)
        }
        else {
            if let index = viewModel.favorites.firstIndex(where: { $0 == button.tag }) {
                viewModel.favorites.remove(at: index)
            }
        }
        
        UserDefaults.standard.set(viewModel.favorites, forKey: "favorites")
    }
}

//extension UIButton {
//    override open var isSelected: Bool {
//        didSet {
//            backgroundColor = isSelected ? UIColor.black : UIColor.clear
//        }
//    }
//}
