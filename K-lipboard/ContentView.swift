//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var clipboardText: String? = nil
    
    @FetchRequest(
        /// 최신 데이터가 위로..
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.stringData, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    private let pasteboard = UIPasteboard.general

    private func setClipboard() {
        pasteboard.string = "Test Clipboard"
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            Text("\(item.stringData ?? "")")
//                            Text(dateFormatter(item.savedDate))
                        }
                    } label: {
                        SideCell(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }
            .onAppear {
                if let text = UIPasteboard.general.string {
                    addItem(text)
                    clipboardText = text
                }
            }
            
        }
    }

    private func addItem(_ text: String = "") {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.stringData = text

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
