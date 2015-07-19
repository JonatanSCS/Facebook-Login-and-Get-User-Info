//
//  ViewController.swift
//  Facebook-Login
//
//  Created by PJ Vea on 6/11/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
   
    var urlNextView: String = ""
    var userName: String = ""
    var userID: String = ""
    var userNumberFriends: String = ""
    
    @IBOutlet var userImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            
            println("Not logged in")
        }
        
        else {
            println("Logged in")
            
            /*
            var birthayRequest = FBSDKGraphRequest(graphPath:"/me/birthday", parameters: nil);
            birthayRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    println("Friends are : \(result)")
                   
                    
                    
                } else {
                    
                    println("Error Getting Friends \(error)");
                    
                }
            }

            */
            
            var fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    //println("Friends are : \(result)")
                    let json = JSON(result!)
                    var summary = json["summary"]
                    println(summary)
                    var numberJSON = summary["total_count"]
                    var number = numberJSON.stringValue
                    println(number)
                    self.userNumberFriends = number
                    
                    
                } else {
                    
                    println("Error Getting Friends \(error)");
                    
                }
            }
  
            
            
            let userRequest = FBSDKGraphRequest(graphPath: "/me/", parameters: nil)
            userRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                
                if error == nil {
                    println("\(result)")
                   
                    let json = JSON(result!)
                    var id = json["id"].string
                    var name = json["name"].string
                    
                    self.userID = id!
                    self.userName = name!
                }
                
                else {
                    println("\(error)")
                }
            
            })
            
            
            let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
            pictureRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if error == nil {
                    println("\(result)")
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                        let json = JSON(result!)
                        var dataImage = json["data"] as JSON
                        var urlImage = dataImage["url"].string
                        var myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string: urlImage!)!)!)
                        
                        self.userImage.image = myImage
                        self.urlNextView = urlImage!
                    })
                }
                
                else {
                    println("\(error)")
                }
            })
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
            }

    // MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            println("Login complete.")
            self.performSegueWithIdentifier("showNew", sender: self)
        }
        else
        {
            println(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        println("User logged out")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextScene = segue.destinationViewController as! NextViewController
        
        nextScene.urlFromView = urlNextView
        nextScene.userNameFromView = userName
        nextScene.userIDFromView = userID
        nextScene.numberFromView = userNumberFriends
    }

}

