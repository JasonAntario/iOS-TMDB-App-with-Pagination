//
//  MovieDetailsViewController.swift
//  iOS TMDB App with Pagination
//
//  Created by Dmitry Sankovsky on 9.01.23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseAndGenreLabel: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    
    var movieId: Int?
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearInfo()
        bindViewModel()
        loadData()
    }
    
    private func clearInfo(){
        titleLabel.text = ""
        releaseAndGenreLabel.text = ""
        overviewText.text = ""
        backdropImage.image = nil
    }
    
    private func loadData(){
        
        if let id = movieId {
            viewModel.fetchMovieDetails(movieId: id)
        }
    }
    
    private func bindViewModel(){
        viewModel.currentMovieDetails.bind({ (movie) in
            DispatchQueue.main.async {
                if let path = movie.backdropPath {
                    if let url = URL(string: K.IMAGE_BASE_URL + path){
                        self.backdropImage.load(url: url)
                    }
                }
                
                var genres = [String]()
                movie.genres.forEach { genre in
                    genres.append(genre.name)
                }
                
                self.titleLabel.text = movie.originalTitle
                self.releaseAndGenreLabel.text = "\(movie.releaseDate), \(genres.joined(separator: ", "))"
                self.overviewText.text = movie.overview
            }
        })
    }
    
}
