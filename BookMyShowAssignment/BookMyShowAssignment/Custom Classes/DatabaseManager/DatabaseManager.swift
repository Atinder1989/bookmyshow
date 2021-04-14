//
//  DatabaseManager.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 14/04/21.
//


import Foundation
import CoreData

enum DatabaseEntity: String {
    case RecentlySearch   = "RecentlySearch"
}

class DatabaseManager: NSObject {
    
    // MARK: - CORE DATA METHODS
    // MARK: - utility routines
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    // MARK: - Core Data stack (generic)
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "BookMyShowAssignment", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
let url = self.applicationDocumentsDirectory.appendingPathComponent("BookMyShowAssignment").appendingPathExtension("sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
let dict: [String: Any] = [NSLocalizedDescriptionKey:
    "Failed to initialize the application's saved data" as NSString,
    NSLocalizedFailureReasonErrorKey:
    "There was an error creating or loading the application's saved data." as NSString,
    NSUnderlyingErrorKey: error as NSError]
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            fatalError("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        return coordinator
    }()
    // MARK: - Core Data stack (iOS 9)
    @available(iOS 9.0, *)
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    // MARK: - Core Data stack (iOS 10)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "BookMyShowAssignment")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data context
    lazy var databaseContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        } else {
            return self.managedObjectContext
        }
    }()
    // MARK: - Core Data save
    private func saveContext () {
        self.databaseContext.performAndWait {
            do {
                if databaseContext.hasChanges {
                    try databaseContext.save()
                }
            } catch {
                let nserror = error as NSError
                print(nserror.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Save Login User Info Data In Database
    func saveMovieInfo(movie: Movie) {
        if isMovieAlreadyExistinCache(movie: movie) {
            return
        }
        if getCacheMovies().count == recentlySearchMaximumCount {
            removeOldestRecentlySearchMovie()
        }
        let entity = RecentlySearch(context: databaseContext)
        entity.adult = movie.adult
        entity.backdrop_path = movie.backdrop_path
        entity.id = "\(movie.id)"
        entity.original_language = movie.original_language
        entity.original_title = movie.original_title
        entity.overview = movie.overview
        entity.popularity = movie.popularity
        entity.poster_path = movie.poster_path
        entity.release_date = movie.release_date
        entity.title = movie.title
        entity.video = movie.video
        entity.vote_average = movie.vote_average
        entity.vote_count = "\(movie.vote_count)"
        entity.timestamp = Date()
        self.saveContext()
    }
    
    // MARK: - Get Login User Info Data From Database
    func getCacheMovies() -> [Movie]{
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DatabaseEntity.RecentlySearch.rawValue)
        var list: [Movie] = []
        do {
            let manageObjectContext = try databaseContext.fetch(fetchRequest)
            if (manageObjectContext.count) > 0 {
                for manageObject in manageObjectContext {
                    var movie = Movie()
                    movie.adult = manageObject.value(forKeyPath: ServiceParsingKeys.adult.rawValue) as? Bool ?? false
                    movie.backdrop_path = manageObject.value(forKeyPath: ServiceParsingKeys.backdrop_path.rawValue) as? String ?? ""
                    let id = manageObject.value(forKeyPath: ServiceParsingKeys.id.rawValue) as? String ?? ""
                    movie.id = Int(id) ?? 0
                    movie.original_language = manageObject.value(forKeyPath: ServiceParsingKeys.original_language.rawValue) as? String ?? ""
                    movie.original_title = manageObject.value(forKeyPath: ServiceParsingKeys.original_title.rawValue) as? String ?? ""
                    movie.overview = manageObject.value(forKeyPath: ServiceParsingKeys.overview.rawValue) as? String ?? ""
                    movie.popularity = manageObject.value(forKeyPath: ServiceParsingKeys.popularity.rawValue) as? Double ?? 0.0
                    movie.poster_path = manageObject.value(forKeyPath: ServiceParsingKeys.poster_path.rawValue) as? String ?? ""
                    movie.release_date = manageObject.value(forKeyPath: ServiceParsingKeys.release_date.rawValue) as? String ?? ""
                    movie.title = manageObject.value(forKeyPath: ServiceParsingKeys.title.rawValue) as? String ?? ""
                    movie.video = manageObject.value(forKeyPath: ServiceParsingKeys.video.rawValue) as? Bool ?? false
                    movie.vote_average = manageObject.value(forKeyPath: ServiceParsingKeys.vote_average.rawValue) as? Double ?? 0.0
                    let voteCount = manageObject.value(forKeyPath: ServiceParsingKeys.vote_count.rawValue) as? String ?? ""
                    movie.vote_count = Int(voteCount) ?? 0
                    movie.timestamp = manageObject.value(forKeyPath: ServiceParsingKeys.timestamp.rawValue) as? Date ?? nil
                    list.append(movie)
                }
                return list
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        return []
    }
    
    private func removeOldestRecentlySearchMovie() {
        let list = self.getCacheMovies()
        print(list.count)
        var minTimeStampValue:Movie = list[0]
           for movie in list {
            if let movieTimeStamp = movie.timestamp, let minTimeStamp = minTimeStampValue.timestamp {
                minTimeStampValue = (movieTimeStamp  < minTimeStamp) ? movie : minTimeStampValue
            }
           }
        deleteOldestCacheMovie(movie: minTimeStampValue)
    }
    
    private func isMovieAlreadyExistinCache(movie:Movie) -> Bool {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DatabaseEntity.RecentlySearch.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(movie.id)")
        do {
            let manageObjectContext = try databaseContext.fetch(fetchRequest)
            if (manageObjectContext.count) > 0 {
               let managedObject = manageObjectContext[0]
                managedObject.setValue(Date(), forKey: ServiceParsingKeys.timestamp.rawValue)
                self.saveContext()
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        return false
    }
    
    private func deleteOldestCacheMovie(movie:Movie) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: DatabaseEntity.RecentlySearch.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(movie.id)")
        do {
            let manageObjectContext = try databaseContext.fetch(fetchRequest)
            if (manageObjectContext.count) > 0 {
            for manageObject in manageObjectContext {
                databaseContext.delete(manageObject)
            }
                self.saveContext()

            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
   
}
