//
//  MovieManager.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import Foundation
import CoreData

class MovieManager  {
    
    public static let shared = MovieManager()
    private let baseURL: String = "https://api.themoviedb.org/3/movie"
    private let apiKey: String = "fd2b04342048fa2d5f728561866ad52a"
    
    func fetchPopularMoviesList(page: Int, onSuccess: @escaping (FetchMovieListResponseModel) -> Void, onError: @escaping (String) -> Void) {
        APIManager.shared.setBaseURL(baseURL)
        APIManager.shared.get(path: "popular?language=en-US&api_key=\(apiKey)&page=\(page)", headers: nil, params: nil, success: { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(FetchMovieListResponseModel.self, from: data)
                onSuccess(response)

            } catch {
                onError(error.localizedDescription)
                print("> \(String(describing: type(of: self))): \(#function): Error: \(error.localizedDescription)")
            }
        }) { (code, message) in
            onError(message)
        }
    }
    
    func getMovieDetail(id: Int, onSuccess: @escaping (GetMovieDetailResponseModel) -> Void, onError: @escaping (String) -> Void) {
        APIManager.shared.setBaseURL(baseURL)
        APIManager.shared.get(path: "\(id)?language=en-US&api_key=\(apiKey)", headers: nil, params: nil, success: { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetMovieDetailResponseModel.self, from: data)
                onSuccess(response)

            } catch {
                onError(error.localizedDescription)
                print("> \(String(describing: type(of: self))): \(#function): Error: \(error.localizedDescription)")
            }
        }) { (code, message) in
            onError(message)
        }
    }
    
    func favoriteMovie(id: Int) {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", id)
        do {
          let result = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
            if result.isEmpty {
                let model = FavoriteMovie(context:CoreDataManager.shared.managedObjectContext)
                model.movieId = Int64(id)
                CoreDataManager.shared.saveContext()
            }
        } catch  {
            print("Core Data Error = \(error.localizedDescription)")
        }
        
    }
    
    func unFavoriteMovie(id: Int) {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", id)
        do {
          let result = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
            if let obj = result.first as? FavoriteMovie {
                CoreDataManager.shared.managedObjectContext.delete(obj)
                CoreDataManager.shared.saveContext()
            }
        } catch  {
            print("Core Data Error = \(error.localizedDescription)")
        }
        
    }
    
    
    func isFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", id)
        do {
          let result = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest)
            return !result.isEmpty

        } catch  {
            print("Core Data Error = \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    
    
}
