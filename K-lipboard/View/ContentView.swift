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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.savedDate, ascending: false)],
        animation: .default)
    var items: FetchedResults<Item>

    @State var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    @State private var showingAlert = false
    
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
                .onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
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
                }
            }
        }
    }
    
    private func delete(offsets: IndexSet) {
        let item = offsets.map{ items[$0]}
        dataController.delete(item: item.first!)
    }
    
    private func deleteAll() {
        items.forEach { item in
            dataController.delete(item: item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
