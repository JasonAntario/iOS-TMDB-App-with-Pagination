//
//  TMDBManager.swift
//  iOS TMDB App with Pagination
//
//  Created by Dmitry Sankovsky on 6.01.23.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case errorDecode
    case failed(error: Error)
    case unknownError
}

struct TMDBApiManager {
    
    static let shared = TMDBApiManager()
    
    func getMovies(page: Int = 1, completion: @escaping (Result<Response, APIError>) -> Void) {
        var components = URLComponents(string: K.BASE_URL + "/popular")!
            components.queryItems = [
                URLQueryItem(name: "api_key", value: K.API_KEY),
                URLQueryItem(name: "page", value: String(page)),
            ]
            guard let url = components.url else {
                completion(.failure(.invalidUrl))
                return
            }
            let urlRequest = URLRequest(url: url, timeoutInterval: 10)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
                if error != nil {
                    print("dataTask error: \(error!.localizedDescription)")
                    completion(.failure(.failed(error: error!)))
                } else if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        print("success")
                        completion(.success(response))
                    } catch {
                        print("decoding error")
                        completion(.failure(.errorDecode))
                    }
                } else {
                    print("unknown dataTask error")
                    completion(.failure(.unknownError))
                }
            }
            .resume()
        }
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, APIError>) -> Void) {
        var components = URLComponents(string: K.BASE_URL + "/\(movieId)")!
            components.queryItems = [
                URLQueryItem(name: "api_key", value: K.API_KEY),
            ]
            guard let url = components.url else {
                completion(.failure(.invalidUrl))
                return
            }
            let urlRequest = URLRequest(url: url, timeoutInterval: 10)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error  in
                if error != nil {
                    print("dataTask error: \(error!.localizedDescription)")
                    completion(.failure(.failed(error: error!)))
                } else if let data = data {
                    do {
                        print(data)
                        let response = try JSONDecoder().decode(MovieDetails.self, from: data)
                        print("success")
                        completion(.success(response))
                    } catch {
                        print("decoding error")
                        completion(.failure(.errorDecode))
                    }
                } else {
                    print("unknown dataTask error")
                    completion(.failure(.unknownError))
                }
            }
            .resume()
        }
}
