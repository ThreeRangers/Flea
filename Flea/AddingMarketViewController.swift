//
//  AddingMarketViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/30/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

class AddingMarketViewController: UIViewController {
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var marketNameTxtField: UITextField!
    
    @IBOutlet weak var facebookPageTxtField: UITextField!
    
    @IBOutlet weak var locationTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var phoneTxtField: UITextField!
    
    @IBOutlet weak var dexcriptionTxtField: UITextField!
    
    @IBOutlet weak var dateFromTxtField: UITextField!

    @IBOutlet weak var dateToTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Q_debug: View did load")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTapImgView(sender: AnyObject) {
        loadImageFrom(.PhotoLibrary)
    }
    
    @IBAction func onSaveMarket(sender: AnyObject) {
        //Upload Market to Parse
        saveMarket()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func saveMarket() {
        var newMarket = Market()
        
        if let image = backgroundImgView.image {
            let imageFile = PFFile(name: "marketImg", data: UIImageJPEGRepresentation(image, 0.4)!)
            newMarket.imageMarket = imageFile!
            print("PFFIle: ",newMarket.imageMarket)
        }
        
        newMarket.name = marketNameTxtField.text
        newMarket.desc = dexcriptionTxtField.text
        newMarket.facebookPage = facebookPageTxtField.text
        newMarket.phone = phoneTxtField.text
        newMarket.email = emailTxtField.text
//        newMarket.location = locationTxtField.text
        
     
        
        self.upLoadMarketToParse(newMarket)
    }
    
    func upLoadMarketToParse(newMarket: Market) {
        newMarket.uploadInfoDataWithImg()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddingMarketViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func loadImageFrom(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // User selected an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickImage(image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // User cancel the image picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickImage(image: UIImage) {
        self.backgroundImgView.image = image
    }
}
