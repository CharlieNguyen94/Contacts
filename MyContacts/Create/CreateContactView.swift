import SwiftUI

struct CreateContactView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EditContactViewModel

    @State private var hasError = false

    var body: some View {
        List {

            Section("General") {

                TextField("Name", text: $viewModel.contact.name)
                                    .keyboardType(.namePhonePad)

                TextField("Email", text: $viewModel.contact.email)
                    .keyboardType(.emailAddress)

                TextField("Phone Number", text: $viewModel.contact.phoneNumber)
                    .keyboardType(.phonePad)

                DatePicker("Birthday",
                           selection: $viewModel.contact.dob,
                           displayedComponents: [.date])
                .datePickerStyle(.compact)

                Toggle("Favourite", isOn: $viewModel.contact.isFavourite)

            }

            Section("Notes") {
                TextField("",
                          text: $viewModel.contact.notes,
                          axis: .vertical)
            }
        }
        .navigationTitle(viewModel.isNew ? "New Contact" : "Update Contact")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    validate()
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Something is wrong!", isPresented: $hasError) {}
    }
}

private extension CreateContactView {

    func validate() {
        if viewModel.contact.isValid {
            do {
                try viewModel.save()
                dismiss()
            } catch {
                print(error)
            }
        } else {
            hasError = true
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let preview = ContactsProvider.shared
            CreateContactView(viewModel: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
        }
    }
}
