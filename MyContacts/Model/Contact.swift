import Foundation
import CoreData

final class Contact: NSManagedObject, Identifiable {

    @NSManaged var dob: Date
    @NSManaged var email: String
    @NSManaged var isFavourite: Bool
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var phoneNumber: String

    var isBirthday: Bool {
        Calendar.current.isDateInToday(dob)
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue(false, forKey: "isFavourite")
    }
}

extension Contact {

    private static var contactsFetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }

    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = contactsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
}
