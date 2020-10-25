//
//  MovieModels.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import Foundation


struct MovieModel: Codable {
    var title: String
    var poster_path: String?
    var id: Int
    var release_date: String
}

struct FetchMovieListResponseModel: Codable {
    var page: Int
    var results: [MovieModel]
    var total_pages: Int
}

struct GetMovieDetailResponseModel : Codable {
    var title: String
    var poster_path: String?
    var id: Int
    var release_date: String
    var vote_count: Int
    var vote_average: Double
    var overview: String?
}
