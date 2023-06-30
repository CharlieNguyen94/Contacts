//
//  CreateContactView.swift
//  MyContacts
//
//  Created by Charlie Nguyen on 30/06/2023.
//

import SwiftUI

struct CreateContactView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {

            Section("General") {

                TextField("Name", text: .constant(""))
                                    .keyboardType(.namePhonePad)

                TextField("Email", text: .constant(""))
                    .keyboardType(.emailAddress)

                TextField("Phone Number", text: .constant(""))
                    .keyboardType(.phonePad)

                DatePicker("Birthday",
                           selection: .constant(.now),
                           displayedComponents: [.date])
                .datePickerStyle(.compact)

                Toggle("Favourite", isOn: .constant(true))

            }

            Section("Notes") {
                TextField("",
                          text: .constant(""),
                          axis: .vertical)
            }
        }
        .navigationTitle("Name here")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {

                }
            }
        }
    }
}

struct CreateContactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateContactView()
        }
    }
}
