import Foundation
import CoreData

struct DefaultsKey {
    static let count = "com.tanookilabs.counter.count"
    static let testData = "com.tanookilabs.counter.testdata"
}

class DataManager {

    static let shared = DataManager()
    var managedObjectContext: NSManagedObjectContext?

    func newCounter() -> Counter? {
        guard let moc = managedObjectContext else { return nil }
        let counter = NSEntityDescription.insertNewObject(forEntityName: "Counter", into: moc) as! Counter
        counter.name = "Unnamed Counter"
        counter.count = 0
        counter.creationDate = Date()
        save()
        return counter
    }

    func save() {
        guard let moc = managedObjectContext else { return }
        do {
            try moc.save()
        } catch {
            fatalError()
        }
    }

    func initializeDataSource(completionClosure: @escaping () -> ()) {
        initilizeCoreDataStack(completionClosure: completionClosure)
    }

    private func initilizeCoreDataStack(completionClosure: @escaping () -> ()) {
        guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = psc

        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                DispatchQueue.main.sync {
                    self.setupTestDataIfNeeded()
                    completionClosure()
                }
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    private func setupTestDataIfNeeded() {
        guard UserDefaults.standard.bool(forKey: DefaultsKey.testData) == false else { return }
        guard let moc = DataManager.shared.managedObjectContext else { return }

        let tasks = ["Pet Kittens", "Take Stairs", "Times Bob says \"No Way\"", "Pomodoros", "Jelly Beans in Jar", "Team Wins", "Team Loses"]

        tasks.forEach { task in
            let counter = NSEntityDescription.insertNewObject(forEntityName: "Counter", into: moc) as! Counter
            counter.name = task
            counter.count = 0
            counter.creationDate = Date()
        }

        do {
            try moc.save()
        } catch {
            fatalError()
        }
        UserDefaults.standard.set(true, forKey: DefaultsKey.testData)
    }
}
