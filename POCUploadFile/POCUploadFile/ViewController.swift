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
    
    /*
    Benodigde onderdelen zoals:
    uploadbutton, activityindicator etc. en globale variabelen.
    */
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var imageGlobal:UIImage? = nil
    var hasToTurn = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
            Upload butten "uitzetten", er is nog geen foto geselecteerd
            activityindicator onzichtbaar maken, is nog niet nodig
        */
        btnUpload.enabled = false
        self.myActivityIndicator.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImage_click(sender: AnyObject) {
        /*
            Opend de imagepicker, is nu ingesteld op "Camera", kan ook van bijvoorbeeld
            de photobibliotheek een foto kiezen.
        */
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*
        Deze functie wordt aangeroepen als er een foto is gekozen bij de imagepicker, het resultaat is de foto (image)
    */
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
        btnUpload.enabled = true
    }
    
    
    @IBAction func upload_click(sender: AnyObject) {
        /*
            Kan alleen als er een foto gekozen is, dubbele check voor deze POC.
        */
        if(imageGlobal != nil) {
            btnUpload.enabled = false
            
            //Waarom eerst uploaden en dan pas draaien?
            self.myActivityIndicator.alpha = 1
            myActivityIndicator.startAnimating()
            
            /*
                Converteer de image naar een jpegRepresentatie (met eventuele convertering)
                Maakt er een base64 string van om op te sturen naar php
                Voeg parameters toe zoals de locatie, schrijver, tekst etc.
                Post de request vervolgens met alle data.
            */
            var imageData = UIImageJPEGRepresentation(imageGlobal!, 0.5)
            var encodedBase64 = imageData.base64EncodedStringWithOptions(.allZeros)
            var parametersWithImage = ["crumbleTitle":"The second Crumble", "author":"ericderegter@gmail.com", "longitude":2.3023984239, "latitude":5.3432423, "crumbletext":"Tweede Crumble die geupload wordt", "image":encodedBase64, "angle":hasToTurn];
            var postrequest = Alamofire.request(.POST, "http://77.175.219.85/fileupload.php", parameters: parametersWithImage as? [String : AnyObject])
            
            postrequest.validate()
            
            /*
                Het antwoord van php.
                Als alles goed gaat komt er een popup met iets van: "Crumble geplaatst"
                Anders een errorbeschrijving in de output van bijvoorbeeld Xcode.
            */
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
        }
    }
}


