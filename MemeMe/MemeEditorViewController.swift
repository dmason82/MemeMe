//
//  ViewController.swift
//  MemeMe
//
//  Created by Doug Mason on 12/4/15.
//  Copyright © 2015 Doug Mason. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    var imagePicker : UIImagePickerController!
    var memedImage : UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let memeTextAttributes :[String:AnyObject] = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2.0
        ]
        topTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        if(imageView.image == nil){
            self.shareButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shiftViewForKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shiftViewForKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func shiftViewForKeyboard(notification: NSNotification){
        switch notification.name{
        case UIKeyboardWillShowNotification:
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            break
        case UIKeyboardWillHideNotification:
            self.view.frame.origin.y += getKeyboardHeight(notification)
            break
        default:
            break
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    @IBAction func pickImageFromLibrary(sender: UIBarButtonItem) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: {()->Void in
        self.enableSharing()})
    }
    
    @IBAction func pickImageFromCamera(sender:UIBarButtonItem){
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: {()->Void in
            self.enableSharing()})
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        self.memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        self .presentViewController(activityView, animated: true , completion: {() ->Void in
            self.save()
        })
    }
    func save(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memedImage = generateMemedImage()
        let meme = Meme( topText: topTextfield.text, bottomText: bottomTextfield.text, image: self.imageView.image, memedImage: generateMemedImage())
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.navigationController?.navigationBarHidden = false
        
        return memedImage
    }
    
    func enableSharing(){
        self.shareButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

