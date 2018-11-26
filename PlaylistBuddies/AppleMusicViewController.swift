//
//  AppleMusicViewController.swift
//  PlaylistBuddies
//
//  Created by Nicole Howard on 11/21/18.
//  Copyright © 2018 Kevin Tran. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

//TODO: Change the entry point before committing anything!!
class AppleMusicViewController: UIViewController, SKCloudServiceSetupViewControllerDelegate {
    
    @IBOutlet var appleMusicButton: UIButton!
    
    @IBAction func appleMusicButtonPressed(_ sender: Any) {
        self.getAuthorizationStatus()
        self.getCapabilities()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cloudServiceSetupViewControllerDidDismiss(_ cloudServiceSetupViewController: SKCloudServiceSetupViewController) {
        print("SKCloudServiceSetupViewController was dismissed.")
    }
    
    /*
     Getting authorization to access the music library
     */
    func getAuthorizationStatus() {
        //get the status of access we have to the users apple music
        let authorizationStatus = SKCloudServiceController.authorizationStatus()
        
        //check the status and perform actions accordingly
        if authorizationStatus == SKCloudServiceAuthorizationStatus.notDetermined {
            //request the authorization for the application
            print("not determined. time to request access.")
            SKCloudServiceController.requestAuthorization { (authorizationStatus) in
                print("requestAuthorization handler: \(authorizationStatus) time to see capabilities")
            }
        } else if authorizationStatus == SKCloudServiceAuthorizationStatus.authorized {
            //get the capabilities that you have
            print("authorized. let's see what the capabilities are")
        } else if authorizationStatus == SKCloudServiceAuthorizationStatus.denied {
            //don't really know what to do here
            print("denied. no need to get capabilites.")
        }
    }
    
    func getCapabilities()  {
        let controller = SKCloudServiceController()
        controller.requestCapabilities { (musicCapability, error) in
            if musicCapability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                print("the device allows playback of apple music catolog tracks.")
            }
            if musicCapability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) {
                print("the device allows subscription to the apple music catalog.")
            }
            if musicCapability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                print("the device allows tracks to be added to the user's music library.")
            } else {
                print("I guess you have no capabilites.")
            }
            if musicCapability.contains(.musicCatalogSubscriptionEligible) && !musicCapability.contains(.addToCloudMusicLibrary) {
                print("You can use the SKCloudSetupViewController.")
                self.showSubscriptionController()
            }
        }
    }
    
    func showSubscriptionController() {
        let setUpController = SKCloudServiceSetupViewController()
        setUpController.delegate = self
        setUpController.load(options: [.action : SKCloudServiceSetupAction.subscribe],
                        completionHandler: { (result, error) in
                            print("loaded")
        })
        self.present(setUpController, animated: true, completion: nil)
    }


}

