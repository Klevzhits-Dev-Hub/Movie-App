//
//  CoreDataManager.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 04.04.2025.
//
import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var posterURL: String?
    @NSManaged public var duration: Int32
    @NSManaged public var releaseDate: Date?
    @NSManaged public var genre: String?
    @NSManaged public var isWatched: Bool
    @NSManaged public var isLiked: Bool
}

extension MovieEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
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
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Movie Operations
    func markAsWatched(movie: Movie) {
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", Int32(movie.id))
            
            do {
                let existingMovies = try context.fetch(fetchRequest)
                
                if let existingMovie = existingMovies.first {
                    if !existingMovie.isWatched {
                        existingMovie.isWatched = true
                        saveContext()
                    }
                } else {
                    let newMovie = MovieEntity(context: context)
                    newMovie.id = Int32(movie.id)
                    newMovie.title = movie.name ?? movie.alternativeName ?? "Unknown"
                    newMovie.posterURL = movie.poster?.url
                    newMovie.duration = Int32(movie.movieLength ?? 0)
                    newMovie.releaseDate = dateFromString(movie.premiere?.world)
                    newMovie.genre = movie.genres?.first?.name
                    newMovie.isWatched = true
                    newMovie.isLiked = false
                    saveContext()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    
    func toggleLike(movie: Movie) {
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", Int32(movie.id))
            
            do {
                let existingMovies = try context.fetch(fetchRequest)
                
                if let existingMovie = existingMovies.first {
                    if existingMovie.isWatched {
                        // Если просмотрен - просто инвертируем лайк
                        existingMovie.isLiked.toggle()
                        saveContext()
                    } else {
                        // Если не просмотрен - при снятии лайка удаляем
                        if existingMovie.isLiked {
                            context.delete(existingMovie)
                            saveContext()
                        }
                    }
                } else {
                    // Добавляем новый лайк
                    let newMovie = MovieEntity(context: context)
                    newMovie.id = Int32(movie.id)
                    newMovie.title = movie.name ?? movie.alternativeName ?? "Unknown"
                    newMovie.posterURL = movie.poster?.url
                    newMovie.duration = Int32(movie.movieLength ?? 0)
                    newMovie.releaseDate = dateFromString(movie.premiere?.world)
                    newMovie.genre = movie.genres?.first?.name
                    newMovie.isWatched = false
                    newMovie.isLiked = true
                    saveContext()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    
    // MARK: - Helpers
    private func dateFromString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    // MARK: - Fetch Methods
    func getWatchedMovies() -> [MovieEntity] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isWatched == YES")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching watched movies: \(error)")
            return []
        }
    }
    
    func getLikedMovies() -> [MovieEntity] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isLiked == YES")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching liked movies: \(error)")
            return []
        }
    }
}
