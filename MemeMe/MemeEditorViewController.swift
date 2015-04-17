//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Benji on 4/8/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    //MARK: - Declarations
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var actionButton: UIBarButtonItem!
    @IBOutlet var pickImageButton: UIBarButtonItem!
    @IBOutlet var takePictureButton: UIBarButtonItem!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var meme: Meme?
    
    //MARK: - View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toolbar.hidden = false
        
        if self.meme == nil {
            self.topTextField.text = ""
            self.bottomTextField.text = ""
        } else {
            self.topTextField.text = self.meme?.topText
            self.bottomTextField.text = self.meme?.bottomText
            self.imageView.image = self.meme?.image
        }
        
        self.takePictureButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.actionButton.enabled = self.imageView.image != nil
        self.saveButton.enabled = self.imageView.image != nil
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        self.topTextField?.textAlignment = .Center
        self.bottomTextField?.textAlignment = .Center
        
        let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 40)!,
            NSStrokeWidthAttributeName : 2
        ]
        
        self.topTextField.defaultTextAttributes = textAttributes
        self.bottomTextField.defaultTextAttributes = textAttributes
    }
    
    
    //MARK: - @IBAction Functions
    
    @IBAction func pickImage() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        let textToShare = "Look at this meme I made with the MemeMe app for iOS!"
        if let imageToShare: UIImage = generateMemedImage() {
            let objectsToShare = [textToShare, imageToShare]
            
            let activityView = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    func cancelButtonAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonAction(sender: UIBarButtonItem) {

        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
        save()
        
        let alertView = UIAlertView(title: "Saved!", message: nil, delegate: self, cancelButtonTitle: nil)
        
        alertView.show()
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertView.dismissWithClickedButtonIndex(0, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func setCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancelButtonAction:")
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setMeme(meme: Meme) {
        self.meme = meme
    }
    
    //MARK: - Save/Generate Meme
    
    func save() {
        //Create Meme
        var meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, image: self.imageView.image!, memedImage: generateMemedImage()!)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage? {
        
        let toolBarHeight = self.toolbar?.frame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        let widthOfView = self.view.bounds.width
        let heightOfView = self.view.bounds.height
        
        let boundsOfImageView = self.imageView.bounds.size
        let frameOfImageView = self.imageView.frame
        
        let heightOfMemedImage = heightOfView - toolBarHeight! - navBarHeight! - 20
        
        let memedImageOrigin = CGPoint(x: 0, y: navBarHeight!)
        let memedImageSize = CGSize(width: widthOfView, height: heightOfMemedImage)
        let memedImageFrame = CGRect(origin: memedImageOrigin, size: memedImageSize)
        
        let boundsOfView = self.view.bounds
        
        //Hide Toolbar, NavBar, and textFields if they have no text
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.toolbar.hidden = true
        
        if topTextField.text == "" {
            self.topTextField.hidden = true
        }
        
        if bottomTextField.text == "" {
            self.bottomTextField.hidden = true
        }
        
        //Render View to an Image
        UIGraphicsBeginImageContextWithOptions(CGSize(width: boundsOfView.width, height: boundsOfView.height - 64), false, 3)
        
        self.view.drawViewHierarchyInRect(CGRectMake(boundsOfView.origin.x, boundsOfView.origin.y - 20, boundsOfView.width, boundsOfView.height), afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show Toolbar and NavBar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.toolbar.hidden = false
        self.topTextField.hidden = false
        self.bottomTextField.hidden = false
        
        return memedImage
    }
    
    
    //MARK: - Image Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.imageView.image = image
        
        self.actionButton.enabled = true
        self.saveButton.enabled = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.topTextField {
            self.bottomTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y), animated: true)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
//    //MARK: - Keyboard Functions
//    
//    func keyboardWillShow(notification: NSNotification) {
//        if bottomTextField.isFirstResponder() {
//            self.view.frame.origin.y -= getKeyboardHeight(notification)
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        self.view.frame.origin.y += getKeyboardHeight(notification)
//    }
//    
//    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
//        return keyboardSize.CGRectValue().height
//    }
//    
//    func subscribeToKeyboardNotifications() {
//        //Keyboard will show notification subscription
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//        
//        //Keyboard will hide notification subscription
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    func unsubscribeFromKeyboardNotifications() {
//        //Keyboard will show notification unsubscription
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        
//        //Keyboard will hide notification subscription
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//    }
    
}

