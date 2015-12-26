import Foundation
import Parse

class Shop: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Shops"
    }
    
    @NSManaged var profileImg: PFFile
    @NSManaged var name: String?
    @NSManaged var facebookLink: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var descriptionText: String?
    @NSManaged var gallery: [PFFile]
}
