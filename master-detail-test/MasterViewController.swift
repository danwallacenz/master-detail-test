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

//            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Report"];
//            request.predicate = nil; // filter on name here
//            request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey: @"creationDate" ascending:NO selector:@selector(compare:)]]; //use localizedStandardCompare: for strings
//            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
//        NSNotificationCenter.defaultCenter().addObserverForName("DatabaseAvailabilityNotification", object: nil, queue: nil, usingBlock: 
        NSNotificationCenter.defaultCenter().addObserverForName("DatabaseAvailabilityNotification", object: nil, queue: nil) { notification in
            if let managedObjectContext = notification.object as? NSManagedObjectContext {
               self.managedObjectContext = managedObjectContext
                NSNotificationCenter.defaultCenter().removeObserver(self, name:"DatabaseAvailabilityNotification", object: nil )
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        
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
//        objects.insertObject(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let report = Report.createInManagedObjectContext(managedObjectContext!)
        println("report=\(report.description)")
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
//                let object = objects[indexPath.row] as NSDate
                if let report = fetchedResultsController?.objectAtIndexPath(indexPath) as? Report{
                    let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                
//                controller.detailItem = object
                    controller.report = report
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return objects.count
        var rows = 0
        if fetchedResultsController?.sections?.count > 0 {
            var sectionInfo = fetchedResultsController!.sections?[section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        return rows
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
//        USE fetchedResultsController?.objectAtIndexPath(indexPath)
        
        if let report = fetchedResultsController?.objectAtIndexPath(indexPath) as? Report {
            cell.textLabel!.text = dateFormatter.stringFromDate(report.creationDate)
        }
        
//        let object = objects[indexPath.row] as NSDate
//        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

