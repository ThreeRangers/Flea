

import UIKit
import Parse 

class Market: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "marketplace"
    }
    
    @NSManaged var displayName: String
    
    var image: UIImage?
    
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var imageName: String?
    @NSManaged var desc: String?
    @NSManaged var date_from: NSDate?
    @NSManaged var date_to: NSDate?
    @NSManaged var imageMarket: PFFile?
    @NSManaged var imageWidth: NSNumber?
    @NSManaged var imageHeight: NSNumber?
    @NSManaged var location: String?
    
    static func getAll(completion: (data: [Market]) -> ()) {
        ParseClient.getAllMaket { (data) -> () in
            completion(data: data)
        }
    }
    
    // load image market
    func loadImage(completion: () -> ()) {
        self.imageMarket!.getDataInBackgroundWithBlock {
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
    
    // load shops by market
    func loadShops(completion:(data: [Shop]) -> ()) {
        ParseClient.getVendorShops(self) { (data) -> () in
            completion(data: data)
        }
    }
}
