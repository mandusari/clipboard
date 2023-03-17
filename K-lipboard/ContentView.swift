//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    private var polling = ClipboardPolling()
    @State var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            Text("\(item.stringData ?? "")")
                        }
                    } label: {
                        SideCell(pinAction: {
                            dataUpdate()
                        }, item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        deleteAll()
                    } label: {
                        Image("delete_all_icon")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width: 50, height: 50)
                }
            }
        }
        .onAppear {
            polling.$string.sink { value in
                guard let text = value else { return }
                addItem(text)
            }.store(in: &cancellable)
        }
    }

    private func dataUpdate() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addItem(_ text: String = "") {
        if isDuplicated(value: text) == false {
            withAnimation {
                let newItem = Item(context: viewContext)
                newItem.stringData = text
                newItem.savedDate = Date()
                dataUpdate()
            }
        }
    }
       
    private func isDuplicated(value: String) -> Bool {
        // 중복 검색할 속성 지정
        let attributeName = "stringData"

        // NSFetchRequest를 생성하여 해당 속성을 검색
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = [attributeName]
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true

        // 중복된 데이터가 있으면 삭제
        do {
            let results = try viewContext.fetch(request) as! [[String: AnyObject]]
            for dict in results {
                let value = dict[attributeName]!
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format: "\(attributeName) == %@", value as! CVarArg)
                let objects = try viewContext.fetch(fetchRequest) as! [NSManagedObject]
                if objects.count >= 1 {
                    return true
                }
            }        } catch {
            print("Error: \\(error)")
        }
        
        return false
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            dataUpdate()
        }
    }
    
    private func deleteAll() {
        withAnimation {
            items.forEach(viewContext.delete)
            dataUpdate()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
