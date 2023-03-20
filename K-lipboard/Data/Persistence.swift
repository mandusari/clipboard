//
//  Persistence.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.stringData = "\(i)"
            newItem.savedDate = Date().addingTimeInterval((Double(i)*1000))
            newItem.isPin = (i%3 == 0)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "K_lipboard")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func dataUpdate() {
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addItem(_ text: String = "") {
        let emptyCheck = text.trimmingCharacters(in: .whitespaces)
        guard emptyCheck.isEmpty == false else { return }
        
        deleteDuplicated(value: text)
        let newItem = Item(context: container.viewContext)
        newItem.stringData = text
        newItem.savedDate = Date()
        newItem.isPin = false
        dataUpdate()
    }
       
    private func deleteDuplicated(value: String) {
        // 중복 검색할 속성 지정
        let attributeName = "stringData"

        // NSFetchRequest를 생성하여 해당 속성을 검색
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = [attributeName]
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true

        do {
            let results = try container.viewContext.fetch(request) as! [[String: AnyObject]]
            for _ in results {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format: "\(attributeName) == %@", value as CVarArg)
                let objects = try container.viewContext.fetch(fetchRequest) as! [NSManagedObject]
                if objects.count > 0 {
                    _ = objects.map{ container.viewContext.delete($0) }
                }
            }
        } catch {
            print("Error: \\(error)")
        }
    }
    func delete(item: Item) {
        container.viewContext.delete(item)
        dataUpdate()
    }
}
