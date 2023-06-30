import SwiftUI

struct ContactRowView: View {

    @Environment(\.managedObjectContext) private var mock

    @ObservedObject var contact: Contact

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(contact.formattedName)
                .font(.system(size: 26, design: .rounded).bold())

            Text(contact.email)
                .font(.callout.bold())

            Text(contact.phoneNumber)
                .font(.callout.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleFavourite()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(contact.isFavourite ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ContactRowView {

    func toggleFavourite() {
        contact.isFavourite.toggle()
        do {
            if mock.hasChanges {
                try mock.save()
            }
        } catch {
            print(error)
        }
    }
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView(contact: .preview())
    }
}
