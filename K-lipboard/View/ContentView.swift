//
//  ContentView.swift
//  K-lipboard
//
//  Created by mandu on 2023/03/04.
//

import SwiftUI
import CoreData
//import UniformTypeIdentifiers
import Combine

struct ContentView: View {
    private let dataController = PersistenceController.shared
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.isPin, ascending: false),
            NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)
        ],
        animation: .default)
    var items: FetchedResults<Item>

    @State private var showingAlert = false
    @State private var selectionItem: Item? = nil
    
    var body: some View {
        NavigationView {
            List(items, id:\.self, selection: $selectionItem) { item in
                NavigationLink {
                    VStack {
                        Text("\(item.stringData ?? "")")
                    }
                } label: {
                    VStack {
                        SideCell(pinAction: {
                            dataController.dataUpdate()
                        }, item: item)
                        .contextMenu {
                            VStack {
                                Text(item.stringData ?? "")
                                Divider()
                                Button(action: {
                                    dataController.delete(item: item)
                                }) {
                                    Text("삭제")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button {
                            showingAlert = true
                        } label: {
                            Label("Delete all clips", systemImage: "trash")
                        }
                        .alert("경고", isPresented: $showingAlert) {
                            Button("삭제", role: .destructive) {
                                deleteAll()
                            }
                        } message: {
                            Text("모두 삭제하시겠습니까?")
                        }
                        
                        Button {
                            dataController.delete(item: selectionItem!)
                        } label: {
                            Label("Delete clip", systemImage: "delete.left")
                        }
                    }
                }
            }
        }
    }
        
    private func deleteAll() {
        items.forEach { item in
            if item.isPin == false {
                dataController.delete(item: item)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
