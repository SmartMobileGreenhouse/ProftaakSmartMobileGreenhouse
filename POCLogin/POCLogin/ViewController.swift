//
//  ViewController.swift
//  POCLogin
//
//  Created by Eric de Regter on 04-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login_click(sender: AnyObject) {
        if(!tfUsername.text.isEmpty && !tfPassword.text.isEmpty) {
            var postrequest = Alamofire.request(.POST, "http://athena.fhict.nl/users/i254244/loginpost.php", parameters: ["username":tfUsername.text, "password":tfPassword.text])
            
            postrequest.validate()
            postrequest.responseJSON(completionHandler: {
                (urlREQ, urlResp, responsestring, error) -> Void in
                if error == nil
                {
                    println(responsestring)
                    //self.parseJsonData(responsestring)
                    var alert = UIAlertController(title: "Login", message: responsestring as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    //Something went wrong
                    println(error)
                }
            })
        }
        else {
            
        }
    }
    
    func parseJsonData(jsonData:AnyObject?) {
        //Create empry array for Pirates
        var jsonConverted = JSON(jsonData!)
        for (index: String, subJson: JSON) in jsonConverted{
            println(index)
            
        }
    }

}

