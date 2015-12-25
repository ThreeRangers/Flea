

import UIKit
import Parse 

class Market: NSObject {
    var name: String?
    var imageName: String?
    var desc: String?
    var fromDate: NSDate?
    var image: UIImage?
    var imageFile: PFFile?
    var imageWidth: CGFloat?
    var imageHeight: CGFloat?
    var location: String?

    
    init(object: PFObject)  {
        self.name = object["name"] as? String!
        self.desc = object["description"] as? String!
        self.fromDate = object["date_from"] as? NSDate!
        self.imageFile = object["imageMarket"] as? PFFile!
        self.location = object["address"] as? String!
        
        self.imageWidth = object["imageWidth"] as? CGFloat
        self.imageHeight = object["imageHeight"] as? CGFloat
    }
    
    // load image market
    func loadImage(completion: () -> ()) {
        self.imageFile!.getDataInBackgroundWithBlock {
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
    func loadShops(completion: () -> ()) {
//        ParseClient.
    }
}
