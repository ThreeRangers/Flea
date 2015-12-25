

import UIKit

let marketViewCellIdentify = "marketViewCellIdentify"

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let transition = NTTransition()
        transition.presenting = operation == .Pop
        return  transition
    }
}

class MarketPlaceViewController:UICollectionViewController ,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{

    var data = [Market]()
    @IBOutlet var collection: UICollectionView!
    
    var imageNameList : Array <NSString> = []
    let delegateHolder = NavigationControllerDelegate()
    
    // load data from Parse
    func loadData() {
        ParseClient.getAllMaket({ (data) -> () in
            self.data = data;
            self.collection.reloadData()
        })
        
        collection.backgroundColor = UIColor.whiteColor()
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.delegate = delegateHolder
        self.view.backgroundColor = UIColor.yellowColor()
       
        loadData()
    }
    
    
    // need refactor !!!
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize  = self.navigationController!.navigationBarHidden ?
        CGSizeMake(screenWidth, screenHeight+20) : CGSizeMake(screenWidth, screenHeight-navigationHeaderAndStatusbarHeight)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }
    
    // need refactor !!!
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition =
        UICollectionViewScrollPosition.CenteredHorizontally.intersect(.CenteredVertically)
        
        let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as String)
        
        let imageHeight = image.size.height*gridWidth/image.size.width
        if imageHeight > 400 {
           position = .Top
        }
        let currentIndexPath = NSIndexPath(forRow: pageIndex, inSection: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        
        
        if pageIndex<2{
            collectionView.setContentOffset(CGPointZero, animated: false)
        }else{
            collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: position, animated: false)
        }
    }
}

extension MarketPlaceViewController {
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    // dynamic resize for the image cell view
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let market = self.data[indexPath.row]
        let imageHeight = market.imageHeight! * gridWidth/market.imageWidth!
        return CGSizeMake(gridWidth, imageHeight)
    }
    
    // init cell collection view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let collectionCell: MarketViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(marketViewCellIdentify, forIndexPath: indexPath) as! MarketViewCell

        collectionCell.market = self.data[indexPath.row] as Market
        if collectionCell.market.image == nil {
            collectionCell.market.loadImage { () -> () in
                self.collection.reloadData()
            }
        }
        
        return collectionCell;
    }
    
    // total count for view
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.data.count;
    }
    
    // select cell event
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let pageViewController = VendorViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        
        pageViewController.market = self.data[indexPath.row] as Market
        
        collectionView.setToIndexPath(indexPath)
        navigationController!.pushViewController(pageViewController, animated: true)
    }
    
}

