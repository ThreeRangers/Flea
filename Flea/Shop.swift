import Foundation
import Parse

class Shop: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Shops"
    }
    
    var image: UIImage?
    
    @NSManaged var profileImg: PFFile
    @NSManaged var name: String?
    @NSManaged var facebookLink: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var descriptionText: String?
    @NSManaged var gallery: [PFFile]
    @NSManaged var likes: NSNumber?
   
    
    // load image market
    func loadImage(completion: () -> ()) {
        self.profileImg.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    print("get image from background")
                    
                    self.image = UIImage(data:imageData)
                    
                    //call back the completed function
                    completion()
                }
            }
        }
    }

}
