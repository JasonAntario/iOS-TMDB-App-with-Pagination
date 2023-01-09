//
//  ViewModel.swift
//  iOS TMDB App with Pagination
//
//  Created by Dmitry Sankovsky on 6.01.23.
//

import Foundation

class ViewModel {
    
    var movies = Dynamic([Movie]())
    var currentMovieDetails = Dynamic(MovieDetails.empty)
    
    var currentPage = 1
    private var currentLastId: Int? = nil
    
    func fetchData(completed: ((Bool) -> Void)? = nil) {
        TMDBApiManager.shared.getMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies.value.append(contentsOf: response.results)
                self?.currentPage = response.page + 1
                completed?(true)
            case .failure(let error):
                print(error.localizedDescription)
                completed?(false)
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int, completed: ((Bool) -> Void)? = nil) {
        TMDBApiManager.shared.getMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentMovieDetails.value = response
                completed?(true)
            case .failure(let error):
                print(error.localizedDescription)
                completed?(false)
            }
        }
    }
}
