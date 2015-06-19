//
//  AddCrumbleTableViewController.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 18-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

protocol AddCrumbleTableViewControllerDelegate {
    func addCrumbleTableViewControllerDidFinish(controller: AddCrumbleTableViewController)
}

class AddCrumbleTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var delegate:AddCrumbleTableViewControllerDelegate? = nil
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet var textFieldTitle: UITextField!
    @IBOutlet var textViewDescription: UITextView!
    @IBOutlet var imageView: UIImageView!
    var imageGlobal:UIImage? = nil
    var imagePicker = UIImagePickerController()
    var hasToTurn = 0
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //btnSave.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnSave_Click(sender: AnyObject) {
        var lat:String = " \(location!.coordinate.latitude)"
        var long:String = " \(location!.coordinate.longitude)"
        var encodedBase64 = ""
        if(!textFieldTitle.text.isEmpty && !textViewDescription.text.isEmpty) {
            if(imageGlobal != nil) {
                var imageData = UIImageJPEGRepresentation(imageGlobal, 0.5)
                encodedBase64 = imageData.base64EncodedStringWithOptions(.allZeros)
            }
            var parametersWithImage = ["crumbleTitle":textFieldTitle.text, "author":"ericderegter@gmail.com", "longitude":long as String, "latitude": lat , "crumbleText":textViewDescription.text, "image":encodedBase64, "angle":hasToTurn]
            var postrequest = Alamofire.request(.POST, "http://77.175.219.85/fileupload.php", parameters: parametersWithImage as? [String : AnyObject])
            postrequest.validate()
            
            postrequest.responseJSON(completionHandler: {
                (urlREQ, urlResp, responsestring, error) -> Void in
                if error == nil
                {
                    //println(responsestring)
                    //var crumble = self.parseJsonData(responsestring)
//                    if(self.delegate != nil)
//                    {
//                        self.delegate!.addCrumbleTableViewControllerDidFinish(self)
//                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    //Something went wrong
                    println("PHP error \(error)")
                }
            })
        }
        else{
            //Alert laten zien.
            
        }
        
        
    }
    
    func parseJsonData(jsonData:AnyObject?) -> CrumbleAnnotation?
    {
        var jsonConverted = JSON(jsonData!)
        println(jsonConverted)
        
        for (index: String, subJson: JSON) in jsonConverted{
            var imagePath = subJson["crumbleImagePath"]
            var imagePathString = ""
            if imagePath == nil {
                imagePathString = ""
            }
            else {
                imagePathString = imagePath.string!
            }
            var lat = subJson["crumbleLat"].double!
            var long = subJson["crumbleLong"].double!
            var id = subJson["crumbleIdentifier"].int!
            var text = subJson["crumbleTekst"].string!
            var author = subJson["crumbleAuthor"].string!
            var date = subJson["crumbleDate"].string!
            var title = subJson["crumbleTitle"].string!
//            let crumble = CrumbleAnnotation(latitude: lat, longitude: long, identifier: id, crumbleText: text, author: author, imagePath: imagePathString, date: date, title: title)
//            let crumble = CrumbleAnnotation(latitude: subJson["crumbleLat"].double!, longitude: subJson["crumbleLong"].double!, identifier: subJson["crumbleIdentifier"].int!, crumbleText: subJson["crumbleTekst"].string!, author: subJson["crumbleAuthor"].string!, imagePath: imagePathString, date: subJson["crumbleDate"].string!, title: subJson["crumbleTitle"].string!)
            return nil
        }
        return nil
    }

    @IBAction func selectImage_Click(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
        imageView.image = image
        imageGlobal = image
        
        /*
        Zorgt dat de foto goed is gedraaid, bijvoorbeeld verschil in portrait of landscape foto. hasToTurn is het aantal graden om goed te draaien in php.
        0 = links (landscape)
        1 = rechts (landscape)
        2 = op de kop
        3 = normaal portrait
        */
        switch imageGlobal!.imageOrientation.rawValue {
        case 0:
            hasToTurn = 0
        case 1:
            hasToTurn = 180
        case 2:
            hasToTurn = 90
        case 3:
            hasToTurn = 270
        default:
            hasToTurn = 0
        }
    }
    
    @IBAction func btnCancel_Click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
