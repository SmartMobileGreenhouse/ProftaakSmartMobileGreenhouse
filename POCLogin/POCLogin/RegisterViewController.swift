//
//  RegisterViewController.swift
//  POCLogin
//
//  Created by Eric de Regter on 04-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfPasswordRepeat: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func gereed_click(sender: AnyObject) {
        var success = true
        var errorMessage = ""
        if(tfUsername.text.isEmpty || tfPassword.text.isEmpty || tfPasswordRepeat.text.isEmpty) {
            success = false
            errorMessage = "All fields are required"
        }
        else if(tfPassword.text != tfPasswordRepeat.text) {
            success = false
            errorMessage = "Passwords must be the same"
        }
        else if(count(tfPassword.text) < 8 || count(tfPasswordRepeat.text) < 8) {
            success = false
            errorMessage = "Minimum password length is 8"
        }
        
        if(success)
        {
            var postrequest = Alamofire.request(.POST, "http://athena.fhict.nl/users/i254244/registerpost.php", parameters: ["username":tfUsername.text, "password":tfPassword.text])
            
            postrequest.validate()
            postrequest.responseJSON(completionHandler: {
                (urlREQ, urlResp, responsestring, error) -> Void in
                if error == nil
                {
                    println(responsestring)
                    //self.parseJsonData(responsestring)
                    var alert = UIAlertController(title: "Register", message: responsestring as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
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
            var alert = UIAlertController(title: "Register", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
}
