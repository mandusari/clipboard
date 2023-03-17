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
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.stringData = text
            newItem.savedDate = Date()
            dataUpdate()
        }
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
