//
//  ViewController.swift
//  POCUploadFile
//
//  Created by Eric de Regter on 05-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var btnUpload: UIButton!
    
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var imageGlobal:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnUpload.enabled = false
        self.myActivityIndicator.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImage_click(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        imageView.image = image
        imageGlobal = image
        btnUpload.enabled = true
        
        
    }
    
    
    @IBAction func upload_click(sender: AnyObject) {
        if(imageGlobal != nil) {
            btnUpload.enabled = false
            //var manager = Manager.sharedInstance
            //manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type" : "application/octet-stream"]
            
            //NOG TOE TE VOEGEN
            //Zet benodigde gegevens in de database (crumbleId + locatie van de afbeelding [bijv. uploads/qwdkjxv92io.jpg]).
            self.myActivityIndicator.alpha = 1
            myActivityIndicator.startAnimating()
            var imageData = UIImageJPEGRepresentation(imageGlobal!, 0.5)
            var encodedBase64 = imageData.base64EncodedStringWithOptions(.allZeros)
            var postrequest = Alamofire.request(.POST, "http://77.175.219.85/fileupload.php", parameters: ["firstName":"karel", "lastName":"jan", "userId":"9", "media":encodedBase64])
            
            postrequest.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                var progressBytes = totalBytesWritten/totalBytesExpectedToWrite
                println(progressBytes)
            }
            
            postrequest.validate()
            
            postrequest.responseJSON(completionHandler: {
                (urlREQ, urlResp, responsestring, error) -> Void in
                if error == nil
                {
                    println(responsestring)
                    //self.parseJsonData(responsestring)
                    var alert = UIAlertController(title: "Upload", message: responsestring as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  {(alert: UIAlertAction!) in self.myActivityIndicator.stopAnimating(); self.myActivityIndicator.alpha = 0; self.btnUpload.enabled = true}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    //Something went wrong
                    println(error)
                    self.myActivityIndicator.stopAnimating()
                    self.myActivityIndicator.alpha = 0
                }
            })
            
            
            
            //            let myUrl = NSURL(string: "http://77.175.219.85/fileupload.php");
            //            let request = NSMutableURLRequest(URL:myUrl!);
            //            request.HTTPMethod = "POST";
            //
            //            let param = [
            //                "firstName": "eric",
            //                "lastName": "deregter",
            //                "userId": "9"
            //            ]
            //
            //            let boundary = generateBoundaryString()
            //
            //            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //
            //            let imageData = UIImageJPEGRepresentation(imageGlobal, 0)
            //            var encodedBase64 = imageData.base64EncodedStringWithOptions(.allZeros)
            //
            //            if(imageData==nil) { return; }
            //
            //            request.HTTPBody = createBodyWithParameters(param, filePathKey: "media", imageDataKey: encodedBase64, boundary: boundary)
            //
            //            myActivityIndicator.startAnimating();
            //
            //
            //            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            //                data, response, error in
            //
            //                if error != nil {
            //                    println("error=\(error)")
            //                    return
            //                }
            //
            //                // You can print out response object
            //                println("******* response = \(response)")
            //
            //                // Print out reponse body
            //                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            //                println("****** response data = \(responseString!)")
            //
            //                dispatch_async(dispatch_get_main_queue(),{
            //                    self.myActivityIndicator.stopAnimating()
            //                    self.imageView.image = nil;
            //                });
            //
            //            }
            //
            //            task.resume()
        }
    }
}


