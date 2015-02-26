//
//  MasterViewController.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 25/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: CoreDataTableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()

    private var addButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
    }

    private var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
    }
    
    // MARK: Persistence
    private var managedObjectContext: NSManagedObjectContext? {
        didSet {
            println("managedObjectContext created in MasterViewController \(managedObjectContext)")

            self.navigationItem.rightBarButtonItem = addButton
            
            let fetchRequest = NSFetchRequest(entityName: "Report")
            fetchRequest.predicate = nil
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                ascending: false,
                selector:"compare:")]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: managedObjectContext!,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        NSNotificationCenter.defaultCenter().addObserverForName("DatabaseAvailabilityNotification", object: nil, queue: nil) { notification in
            if let managedObjectContext = notification.object as? NSManagedObjectContext {
               self.managedObjectContext = managedObjectContext
                NSNotificationCenter.defaultCenter().removeObserver(self, name:"DatabaseAvailabilityNotification", object: nil )
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        let report = Report.createInManagedObjectContext(managedObjectContext!)
        println("report=\(report.description)")
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let report = fetchedResultsController?.objectAtIndexPath(indexPath) as? Report{
                    let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                    controller.report = report
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if let report = fetchedResultsController?.objectAtIndexPath(indexPath) as? Report {
            cell.textLabel!.text = dateFormatter.stringFromDate(report.creationDate)
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let reportToDelete = fetchedResultsController?.objectAtIndexPath(indexPath) as? Report {
                managedObjectContext?.deleteObject(reportToDelete);
                
                // handle the case when there is no more reports or the displayed row is the one being deleted
                resetDetailControllerIfNeededForDeletionOfRowAtIndexPath(indexPath)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    private func resetDetailControllerIfNeededForDeletionOfRowAtIndexPath(indexPath: NSIndexPath){
        if splitViewController != nil {
            if let detailNavigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as? UINavigationController {
                if let detailController = detailNavigationController.topViewController as? DetailViewController {
                    if fetchedResultsController?.fetchedObjects?.count == 1 || detailController.report == fetchedResultsController?.objectAtIndexPath(indexPath) as? Report{
                        detailController.detailDescriptionLabel.text = "Detail view content goes here"
                    }
                }
            }
        }
    }
}

