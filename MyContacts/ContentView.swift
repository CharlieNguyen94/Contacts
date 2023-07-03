import SwiftUI

struct SearchConfig: Equatable {

    enum Filter {
        case all, favourite
    }

    var query: String = ""
    var filter: Filter = .all

}

struct ContentView: View {

    @State private var contactToEdit: Contact?
    @State private var searchConfig: SearchConfig = .init()

    @FetchRequest(fetchRequest: Contact.all()) private var contacts

    var provider = ContactsProvider.shared

    var body: some View {
        NavigationStack {
            ZStack {
                if contacts.isEmpty {
                    NoContactsView()
                } else {
                    List {
                        ForEach(contacts) { contact in
                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    ContactDetailView(contact: contact)
                                } label: {}
                                    .opacity(0)

                                ContactRowView(provider: provider, contact: contact)
                                    .swipeActions(allowsFullSwipe: true) {

                                        Button(role: .destructive) {
                                            do {
                                                try provider.delete(contact, in: provider.newContext)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)

                                        Button(role: .destructive) {
                                            contactToEdit = contact
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchConfig.query)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        contactToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {

                        Section {
                            Text("Filter")
                            Picker(selection: $searchConfig.filter) {
                                Text("All").tag(SearchConfig.Filter.all)
                                Text("Favourites").tag(SearchConfig.Filter.favourite)
                            } label: {
                                Text("Filter favourites")
                            }

                        }

                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                            .font(.title2)
                    }

                }
            }
            .sheet(item: $contactToEdit, onDismiss: {
                contactToEdit = nil
            }, content: { contact in
                NavigationStack {
                    CreateContactView(viewModel: .init(provider: provider, contact: contact))
                }
            })
            .navigationTitle("Contacts")
            .onChange(of: searchConfig) { newConfig in
                contacts.nsPredicate = Contact.filter(with: newConfig)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = ContactsProvider.shared
        ContentView(provider: preview)
            .environment(\.managedObjectContext, preview.viewContext)
            .previewDisplayName("Contacts With Data")
            .onAppear {
                Contact.makePreview(count: 10, in: preview.viewContext)
            }

        let emptyPreview = ContactsProvider.shared
        ContentView(provider: emptyPreview)
            .environment(\.managedObjectContext, emptyPreview.viewContext)
            .previewDisplayName("Contacts With No Data")
    }
}
