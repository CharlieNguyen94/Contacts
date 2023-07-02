import SwiftUI

struct ContentView: View {

    @State private var isShowingNewContact = false

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

                                ContactRowView(contact: contact)
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                isShowingNewContact.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingNewContact) {
                        NavigationStack {
                            CreateContactView(viewModel: .init(provider: provider))
                        }
                    }
                    .navigationTitle("Contacts")
                }
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
