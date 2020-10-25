//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit

class MovieDetailViewController: MovieAppBaseViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    //MARK: Variables
    var movieId : Int?
    
    //MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieDetail()
        super.embedRightBarItem(icon: UIImage(named: "star"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let id = self.movieId {
            setButtonIcon(isFavorite: MovieManager.shared.isFavorite(id: id))
        }
        
    }
    
    override func rightBarTapped(_ sender: UIBarButtonItem) {
        if let id = self.movieId {
            if MovieManager.shared.isFavorite(id: id) {
                MovieManager.shared.unFavoriteMovie(id: id)
                setButtonIcon(isFavorite: false)
            } else {
                MovieManager.shared.favoriteMovie(id: id)
                setButtonIcon(isFavorite: true)
            }
        }
    }
    
    
    
    //MARK: Fetch Data Function
    fileprivate func setMovieDetail() {
        if let id = self.movieId {
            MovieManager.shared.getMovieDetail(id: id) { (response) in
                DispatchQueue.main.async { [self] in
                    self.titleLabel.text = response.title
                    self.voteLabel.text = "\(response.vote_count) times voted, avarage: \(response.vote_average)"
                    self.setPosterImage(path: response.poster_path)
                    self.detailTextView.text = response.overview ?? ""
                }
            } onError: { (error) in
                DispatchQueue.main.async {
                    self.showErrorPopup(message: error)
                }
            }

        }
    }
    
    //MARK: Helper Functions
    func setPosterImage(path: String?) {
       let imageUrlString = "https://image.tmdb.org/t/p/w300\(path ?? "")"
        if let url = URL(string: imageUrlString) {
            posterImageView.load(url: url)
        }
    }
    
    fileprivate func setButtonIcon(isFavorite: Bool) {
        if let barItem = self.navigationItem.rightBarButtonItem {
            if isFavorite {
                barItem.image = UIImage(named: "star")
            } else {
                barItem.image = UIImage(named: "emptyStar")
            }
        }
    }
    
}
