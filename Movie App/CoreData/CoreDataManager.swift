//
//  CoreDataManager.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 04.04.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - CoreData Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("⚠️ CoreData Save Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Movie Operations
    func markAsWatched(movie: Movie) {
        if let existingMovie = fetchMovie(by: movie.id) {
            if !existingMovie.isWatched {
                existingMovie.isWatched = true
                saveContext()
            }
        } else {
            let newMovie = MovieEntity(context: context)
            configureMovieEntity(newMovie, with: movie)
            newMovie.isWatched = true
            newMovie.isLiked = false
            saveContext()
        }
    }
    
    func toggleLike(movie: Movie) {
        if let existingMovie = fetchMovie(by: movie.id) {
                if existingMovie.isLiked {
                    context.delete(existingMovie)
                } else {
                    existingMovie.isLiked = true
                }
        } else {
            let newMovie = MovieEntity(context: context)
            configureMovieEntity(newMovie, with: movie)
            newMovie.isWatched = false
            newMovie.isLiked = true
        }
        saveContext()
    }
    
    func containsMovie(withId id: Int) -> Bool {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int32(id))
        request.fetchLimit = 1
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    // MARK: - Fetch Methods
    func getWatchedMovies() -> [MovieEntity] {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isWatched == YES")
        return (try? context.fetch(request)) ?? []
    }
    
    func getLikedMovies() -> [MovieEntity] {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isLiked == YES")
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Private Helpers
    private func fetchMovie(by id: Int) -> MovieEntity? {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", Int32(id))
        return try? context.fetch(request).first
    }
    
    private func configureMovieEntity(_ entity: MovieEntity, with movie: Movie) {
        entity.id = Int32(movie.id)
        entity.title = movie.name ?? movie.alternativeName ?? "Unknown"
        entity.posterURL = movie.poster?.url
        entity.duration = Int32(movie.movieLength ?? 0)
        entity.genre = movie.genres?.first?.name ?? "Unknown Genre"
        entity.releaseDate = dateFromString(movie.premiere?.world)
    }
    
    private func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}
