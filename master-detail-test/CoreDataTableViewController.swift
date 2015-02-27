//
//  CoreDataTableViewController.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 25/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//
// This class mostly just copies the code from NSFetchedResultsController's documentation page
//   into a subclass of UITableViewController.
//
// Just subclass this and set the fetchedResultsController.
// The only UITableViewDataSource method you'll HAVE to implement is tableView:cellForRowAtIndexPath:.
// And you can use the NSFetchedResultsController method objectAtIndexPath: to do it.
//
// Remember that once you create an NSFetchedResultsController, you CANNOT modify its @propertys.
// If you want new fetch parameters (predicate, sorting, etc.),
//  create a NEW NSFetchedResultsController and set this class's fetchedResultsController @property again.
//

import UIKit
import CoreData

    // TODO: incomplete implementation
class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // The controller (this class fetches nothing if this is not set).
     var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            if let frc = fetchedResultsController {
                if frc != oldValue {
                    setUpFetchedResultsController()
                }
            } else {
                tableView.reloadData()
            }
        }
    }
    
    private func setUpFetchedResultsController() {
        fetchedResultsController!.delegate = self
        if title == nil && (navigationController == nil || navigationItem.title == nil) {
            title = fetchedResultsController!.fetchRequest.entity?.name
        }
        performFetch()
    }
    
    // Set to YES to get some debugging output in the console.
    var debug = true
    
    // Turn this on before making any changes in the managed object context that
    //  are a one-for-one result of the user manipulating rows directly in the table view.
    // Such changes cause the context to report them (after a brief delay),
    //  and normally our fetchedResultsController would then try to update the table,
    //  but that is unnecessary because the changes were made in the table already (by the user)
    //  so the fetchedResultsController has nothing to do and needs to ignore those reports.
    // Turn this back off after the user has finished the change.
    // Note that the effect of setting this to NO actually gets delayed slightly
    //  so as to ignore previously-posted, but not-yet-processed context-changed notifications,
    //  therefore it is fine to set this to YES at the beginning of, e.g., tableView:moveRowAtIndexPath:toIndexPath:,
    //  and then set it back to NO at the end of your implementation of that method.
    // It is not necessary (in fact, not desirable) to set this during row deletion or insertion
    //  (but definitely for row moves).
    var suspendAutomaticTrackingOfChangesInManagedObjectContext = false
    
    
    // MARK: Fetching
    // Causes the fetchedResultsController to refetch the data.
    // You almost certainly never need to call this.
    // The NSFetchedResultsController class observes the context
    //  (so if the objects in the context change, you do not need to call performFetch
    //   since the NSFetchedResultsController will notice and update the table automatically).
    // This will also automatically be called if you change the fetchedResultsController @property.
    func performFetch() {
        var error: NSError?
        fetchedResultsController?.performFetch(&error)
        if let err = error {
            println("ERROR: \(err.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController?.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = fetchedResultsController?.sections![section] as? NSFetchedResultsSectionInfo {
            return sectionInfo.name
        }
        return nil
    }

    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    }

    // Causes a strange bug where a '2' appears in the vertical center on the right of the table view.
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        return fetchedResultsController?.sectionIndexTitles
//    }

    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let indexSet = NSIndexSet(index: sectionIndex)
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Update:
            break
        case NSFetchedResultsChangeType.Move:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }
}
