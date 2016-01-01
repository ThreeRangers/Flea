

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
    @NSManaged var phone: String?
    @NSManaged var facebookPage: String?
    @NSManaged var imageMarket: PFFile?
    @NSManaged var imageWidth: NSNumber?
    @NSManaged var imageHeight: NSNumber?
    @NSManaged var email: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var loves : NSNumber?

   
    
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
    
    var finishCallback: ((market: Market) -> Void)?
    
    func uploadInfoDataWithImg() {
        if let file: PFFile = imageMarket{
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    //                    self.saveData()
                    //2
                } else if let error = error {
                    //3
                    print("error uploading file",error)
                    return
                }
                }, progressBlock: { percent in
                    //4
                    print("Uploaded: \(percent)%")
            })
        }
        self.saveData()
    }
    func saveData() {
        saveInBackgroundWithBlock({ (success, error) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            self.finishCallback?(market: self)
        })
    }
}
