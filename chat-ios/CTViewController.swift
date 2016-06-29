//
//  CTViewController.swift
//  chat-ios
//
//  Created by Brian Correa on 6/7/16.
//  Copyright © 2016 Velocity 360. All rights reserved.
//

import UIKit

class CTViewController: UIViewController {
    
    static var currentUser = CTProfile() //shared across the application
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(CTViewController.userLoggedIn(_:)),
                                       name: Constants.kUserLoggedInNotification,
                                       object: nil)
        
        let logoImageView = UIImageView(image: UIImage(named: "logo-icon.png"))
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: logoImageView.frame.size.width, height: logoImageView.frame.size.height+10))
        logoView.addSubview(logoImageView)
        
        self.navigationItem.titleView = logoImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CurrentUser: \(CTViewController.currentUser.id)")   
    }
    
    func userLoggedIn(notification: NSNotification){
        if let user = notification.userInfo!["user"] as? Dictionary<String, AnyObject>{
            CTViewController.currentUser.populate(user)
        }
    }
    
    func postLoggedInNotification(currentUser: Dictionary<String, AnyObject>){
        let notification = NSNotification(
            name: Constants.kUserLoggedInNotification,
            object: nil,
            userInfo: ["user":currentUser]
        )
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotification(notification)
    }
    
    func checkLoggedIn()-> Bool {
        if (CTViewController.currentUser.id != nil){
            return true
        }
        
        let alert = UIAlertController(
            title: "Not Logged In",
            message: "Please log in or register to chat.",
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.startLoginRegisterSequence()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        return false
    }
    
    func startLoginRegisterSequence(){
        let loginRegisterVc = CTAccountViewController()
        loginRegisterVc.showsBackButton = true
        let navCtr = UINavigationController(rootViewController: loginRegisterVc)
        navCtr.navigationBar.barTintColor = UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
        self.presentViewController(navCtr, animated: true, completion: nil)
    }
    
    func exit(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureCustomBackButton(){
    
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_icon.png")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}