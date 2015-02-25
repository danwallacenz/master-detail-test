//
//  AppDelegate.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 25/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            println("managedObjectContext created \(managedObjectContext)")
        }
    }

    var managedDocument: UIManagedDocument? {
        didSet {
            println("managedDocument found \(managedDocument)")
            if managedDocument?.documentState == UIDocumentState.Normal {
                managedObjectContext = managedDocument?.managedObjectContext
            }
//            if(self.managedDocument.documentState == UIDocumentStateNormal){
//                self.managedObjectContext = self.managedDocument.managedObjectContext;
//                
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextChanged:) name: NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
//                
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextSaved:) name: NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
//                
//                NSLog(@"INFO - database is %@/%@", [self.managedDocument.fileURL.absoluteString stringByRemovingPercentEncoding], @"StoreContent/persistentStore");
//            }else{
//                
//                NSString *documentState;
//                switch (self.managedDocument.documentState) {
//                case UIDocumentStateNormal:
//                    documentState = @"UIDocumentStateNormal";
//                    break;
//                case UIDocumentStateClosed:
//                    documentState = @"UIDocumentStateNormal";
//                    break;
//                case UIDocumentStateInConflict:
//                    documentState = @"UIDocumentStateInConflict";
//                    break;
//                case UIDocumentStateSavingError:
//                    documentState = @"UIDocumentStateSavingError";
//                    break;
//                case UIDocumentStateEditingDisabled:
//                    documentState = @"UIDocumentStateEditingDisabled";
//                    break;
//                default:
//                    break;
//                }
//                NSLog(@"Document state is not normal %@, see UIDocumentState ", documentState );
//            }
        }
    }
    // MARK: Persistence
    
    private func createManagedDocument() {
        if let documentsDirectory = applicationDocumentsDirectory() {
            println("documentsDirectory = \(documentsDirectory)")
            let documentName = "master-detail-test"
            let databaseURL = documentsDirectory.URLByAppendingPathComponent(documentName)
            println("databaseURL = \(databaseURL)")
            
            let managedDocument = UIManagedDocument(fileURL: databaseURL)
            
            if NSFileManager.defaultManager().fileExistsAtPath(databaseURL.path!){
                managedDocument.openWithCompletionHandler( {
                    success in
                        if success {
                            self.managedDocument = managedDocument
                        }else {
                            println("ERROR: Could not open database file")
                        }
                    })
            } else {
                managedDocument.saveToURL(databaseURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler:  {
                    success in
                        if success {
                            self.managedDocument = managedDocument
                        }else {
                            println("ERROR: Could not create database file")
                        }
                    })
            }
        }
    }
    
    private func applicationDocumentsDirectory() -> NSURL? {
        
        if let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as? NSURL {
             return url
        }
        return nil
    }
    

    
    // MARK: UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        createManagedDocument()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

}

