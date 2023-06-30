import SwiftUI

struct CreateContactView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EditContactViewModel

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
        .navigationTitle("Name here")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    do {
                        try viewModel.save()
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateContactView(viewModel: .init(provider: .shared))
        }
    }
}
