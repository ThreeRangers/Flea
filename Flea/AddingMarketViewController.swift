//
//  AddingMarketViewController.swift
//  Flea
//
//  Created by Sinh Quyen Ngo on 12/30/15.
//  Copyright © 2015 ThreeStrangers. All rights reserved.
//

import UIKit

let myDateFormat = "dd-MM-yyyy HH:mm"

class AddingMarketViewController: UIViewController, AddLocationMapViewControllerDelegate {
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var marketNameTxtField: UITextField!
    
    @IBOutlet weak var facebookPageTxtField: UITextField!
    
    @IBOutlet weak var locationTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var phoneTxtField: UITextField!
    
    @IBOutlet weak var dexcriptionTxtField: UITextField!
    
    @IBOutlet weak var dateFromTxtField: UITextField!
    
    var locationUpdated: CLLocation!
    
    @IBOutlet weak var dateToTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Q_debug: View did load")
        dateFromTxtField.delegate = self
        dateToTxtField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHiden:"), name:UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Prepare for segueeee")
        if (segue.identifier == "ShowAddLocationMap") {
            let vc = segue.destinationViewController as! AddLocationMapViewController
            vc.currentLocation = locationUpdated
            vc.delegate = self
        }
    }
    
    func updateLocation(addLocationViewController: AddLocationMapViewController, locationMark: Dictionary<String, String>, location: CLLocation) {
        locationTxtField.text = locationMark["name"]
        locationUpdated = location
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
        newMarket.date_from = NSDate(string: dateFromTxtField.text, formatString: myDateFormat)
        newMarket.date_to = NSDate(string: dateToTxtField.text, formatString: myDateFormat)
        //        newMarket.location = locationTxtField.text
        newMarket.location = PFGeoPoint(location: locationUpdated)
        newMarket.address = locationTxtField.text
        
        
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

extension AddingMarketViewController: UITextFieldDelegate {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
       
    }
    
    func keyboardWasHiden(notification: NSNotification) {
        
  
    }
    
    @IBAction func onTapLocationView(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("ShowAddLocationMap", sender: self)
    }
    
    
    @IBAction func dateFromBeginEditing(sender: UITextField) {
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("dateFromPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    @IBAction func dateToBeginEditing(sender: UITextField) {
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("dateToPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func dateFromPickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //
        //        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = myDateFormat
        dateFromTxtField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func dateToPickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        //
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //
        //        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateFormat = myDateFormat
        dateToTxtField.text = dateFormatter.stringFromDate(sender.date)
        
    }
}