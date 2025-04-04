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
    
    // Контейнер для работы с Core Data
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieModel") // Имя должно совпадать с вашим .xcdatamodeld!
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Ошибка загрузки Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Контекст для сохранения/изменения данных
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Сохранение контекста
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }
    
    func addMovie(_ movie: Movie, isFavorite: Bool, isWatched: Bool) {
        let entity = MovieEntity(context: context)
        entity.id = Int64(movie.id)
        entity.name = movie.name ?? "No name"
        entity.posterURL = movie.poster?.url ?? ""
        entity.premiere = movie.premiere?.world ?? ""
        entity.genre = ""
        entity.durationString = movie.durationString
        entity.isFavorite = isFavorite
        entity.isWatched = isWatched
        saveContext()
    }
    
    func isMovieInDatabase(id: Int) -> Bool {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func fetchFavorites() -> [MovieEntity] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        return (try? context.fetch(request)) ?? []
    }

}
