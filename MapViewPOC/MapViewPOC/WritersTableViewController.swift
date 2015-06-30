//
//  WritersTableViewController.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 30-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WritersTableViewController: UITableViewController {
    
    var selectedCategory = "Categories"
    var needsToLoadData = true
    
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = selectedCategory
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        getWriters()
        needsToLoadData = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = selectedCategory
        if(needsToLoadData) {
            //Nog een algoritme maken zodat de juiste data wordt opgehaald
            getWriters()
        }
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
        return users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("WriterCell", forIndexPath: indexPath) as! UITableViewCell
    cell.textLabel?.text = users[indexPath.item].profilename
    // Configure the cell...
    
    return cell
    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if(segue.identifier == "selectCategorySegue") {
            var navController: UINavigationController = segue.destinationViewController as! UINavigationController
            
            var categoryViewController: CategoryTableViewController = navController.topViewController as! CategoryTableViewController
            categoryViewController.selectedCategory = selectedCategory
        }
        
    }
    
    func getWriters() {
        var request = Alamofire.request(.POST, "http://77.175.219.85/getcrumbles.php", parameters: ["crumble":"user"])
        request.validate()
        /*
        Het antwoord van php.
        Als alles goed gaat komt er een popup met iets van: "Crumble geplaatst"
        Anders een errorbeschrijving in de output van bijvoorbeeld Xcode.
        */
        request.responseJSON(completionHandler: {
            (urlREQ, urlResp, responsestring, error) -> Void in
            if error == nil
            {
                //Uncomment als er iets mis is
                //println(responsestring)
                println("Opnieuw laden..")
                self.parseJsonData(responsestring)
                
            }
            else
            {
                //Something went wrong
                println(error)
            }
        })
    }
    
    func parseJsonData(jsonData:AnyObject?)
    {
        users.removeAll(keepCapacity: false)
        var jsonConverted = JSON(jsonData!)
        //Werkt blijkbaar alleen als subJson een array met objecten is!! (komt van swiftyjson af)
        for (index: String, subJson: JSON) in jsonConverted{
            var imagePath = subJson["profileimagePath"].string
            var imagePathString = ""
            if imagePath == nil {
                imagePathString = ""
            }
            else {
                imagePathString = imagePath!
            }
            let user = User(username: subJson["username"].string!, profilename: subJson["profilename"].string!, imagePath: imagePathString)
            users.append(user)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        tableView.reloadData()
    }
    
    
    @IBAction func unwindFromModalViewController(sender: UIStoryboardSegue) {
        if(sender.sourceViewController.isKindOfClass(CategoryTableViewController)) {
            var categoryTableViewController = sender.sourceViewController as! CategoryTableViewController
            if(self.selectedCategory != categoryTableViewController.selectedCategory) {
                self.selectedCategory = categoryTableViewController.selectedCategory
                println("Selected \(categoryTableViewController.selectedCategory)")
                self.needsToLoadData = true
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            else
            {
                println("Cancel clicked!")
                self.needsToLoadData = false
            }
            
        }
    }
    
}
