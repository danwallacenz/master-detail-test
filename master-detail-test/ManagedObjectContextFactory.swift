//
//  ManagedObjectContextFactory.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 26/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectContextFactory: NSObject {
    
    var documentName:String = "Reports"
    
    init(documentName: String){
        self.documentName = documentName
    }
    
    override convenience init() {
        self.init(documentName: "Reports")
    }
    
    // MARK: Persistence
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            println("managedObjectContext created \(managedObjectContext)")
            NSNotificationCenter.defaultCenter().postNotificationName("DatabaseAvailabilityNotification", object: managedObjectContext)
        }
    }
    
    private var managedDocument: UIManagedDocument? {
        didSet {
            if managedDocument != nil {
                println("managedDocument found \(managedDocument)")
                
                if managedDocument!.documentState == UIDocumentState.Normal {
                    
                    managedObjectContext = managedDocument!.managedObjectContext
                    
                    NSNotificationCenter.defaultCenter() .addObserver(self, selector: "contextChanged:", name: NSManagedObjectContextObjectsDidChangeNotification, object: self.managedObjectContext)
                    NSNotificationCenter.defaultCenter() .addObserver(self, selector: "contextSaved:", name: NSManagedObjectContextDidSaveNotification, object: self.managedObjectContext)
                    
                    println("Database is \(managedDocument!.fileURL.absoluteString?.stringByRemovingPercentEncoding)/StoreContent/persistentStore")
                    
                } else { // error
                    
                    var documentState = ""
                    switch managedDocument!.documentState {
                    case UIDocumentState.Closed:
                        documentState = "Closed"
                    case UIDocumentState.InConflict:
                        documentState = "InConflict"
                    case UIDocumentState.SavingError:
                        documentState = "SavingError"
                    case UIDocumentState.EditingDisabled:
                        documentState = "EditingDisabled"
                    default: break
                    }
                    println("ERROR: Document state is \(documentState)")
                }
            }
        }
    }
    
    func createManagedDocument() {
        if let documentsDirectory = applicationDocumentsDirectory() {
            println("documentsDirectory = \(documentsDirectory)")
//            let documentName = "Reports"
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
    
    func contextChanged(notification: NSNotification){
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? NSSet {
            println("\(insertedObjects.count) objects inserted (in memory)")
        }
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? NSSet {
            println("\(deletedObjects.count) objects deleted (in memory)")
        }
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet {
            println("\(updatedObjects.count) objects updated (in memory)")
        }
    }
    
    func contextSaved(notification: NSNotification){
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? NSSet {
            println("\(insertedObjects.count) objects inserted (in database)")
        }
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? NSSet {
            println("\(deletedObjects.count) objects deleted (in database)")
        }
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? NSSet {
            println("\(updatedObjects.count) objects updated (in database)")
        }
    }
}
