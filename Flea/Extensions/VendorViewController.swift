
import Foundation
import UIKit

let VendorViewCellIdentify = "VendorViewCellIdentify"

class VendorViewController : UICollectionViewController, NTTransitionProtocol , VendorControllerProtocol{
    var market : Market!
    var shops : [Shop]!
    var pullOffset = CGPointZero
    
    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: NSIndexPath){
        super.init(collectionViewLayout:layout)
        
        let collectionView :UICollectionView = self.collectionView!
        collectionView.pagingEnabled = true
        collectionView.registerClass(ShopViewCell.self, forCellWithReuseIdentifier: shopCellIdentify)
        collectionView.setToIndexPath(indexPath)
        
        collectionView.performBatchUpdates({collectionView.reloadData()}, completion: { finished in
            if finished {
                collectionView.scrollToItemAtIndexPath(indexPath,atScrollPosition:.CenteredHorizontally, animated: false)
            }});

        loadData();
    }
    
    // load shops data to collection view by the market
    func loadData() {
        market.loadShops { (data) -> () in
            self.shops = data
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewCellScrollViewContentOffset() -> CGPoint{
        return self.pullOffset
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
}


extension VendorViewController {
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3;
    }
    
    // init cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: ShopViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(VendorViewCellIdentify, forIndexPath: indexPath) as! ShopViewCell
        
        cell.shop = self.shops[indexPath.row] as Shop
        
        cell.tappedAction = {}
        cell.pullAction = { offset in
            self.pullOffset = offset
            self.navigationController!.popViewControllerAnimated(true)
        }
        cell.setNeedsLayout()
        return cell
    }
}