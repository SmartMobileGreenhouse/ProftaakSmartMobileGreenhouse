//
//  CrumbleDetailViewController.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 19-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit

class CrumbleDetailViewController: UIViewController {
    var crumble: CrumbleAnnotation?
    
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblAuthor: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = crumble?.title
        lblAuthor.text = crumble?.author
        lblDate.text = crumble?.date
        navigationController?.navigationBar.barTintColor = UIColor(red: 224/255, green: 172/255, blue: 37/255, alpha: 1)
        if(crumble?.imagePath != "")
        {
            //Load image
            var urlString = "http://77.175.219.85/" + crumble!.imagePath
            let url = NSURL(string: urlString)
            let data = NSData(contentsOfURL: url!)
            imageView.image = UIImage(data: data!)
        }
        
        
    }
}
