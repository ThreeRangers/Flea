

import UIKit

class Market: NSObject {
    var name: String?
    var imageName: String?
    
    init(dictionary: NSDictionary)  {
        self.name = dictionary["name"] as? String!
        self.imageName = dictionary["imageName"] as? String!

    }
}
