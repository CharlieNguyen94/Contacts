import SwiftUI

struct NoContactsView: View {
    var body: some View {
        VStack {
            Text("👀 No Contacts")
                .font(.largeTitle.bold())
            Text("Create some contacts?")
                .font(.callout)
        }
    }
}

struct NoContactsView_Previews: PreviewProvider {
    static var previews: some View {
        NoContactsView()
    }
}
