//
//  MoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(model: MovieModel) {
        self.titleLabel.text = model.title
        self.releaseDateLabel.text = model.release_date
        starImageView.isHidden = !MovieManager.shared.isFavorite(id: model.id)
        #warning("if I try to fetch image with cell's real width, images re not found. So i send static width.")
        if let url = URL(string: "https://image.tmdb.org/t/p/w300\(model.poster_path ?? "")") {
            posterImageView.load(url: url)
        }
    }
}

