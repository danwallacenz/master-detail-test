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
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return fetchedResultsController?.sectionIndexTitles
    }
//    // MARK: - UITableViewDataSource
//    
////    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
////        return self.fetchedResultsController!.sections.count
////    }
//        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//            if let sections = fetchedResultsController?.sections {
//                return sections.count
//            }
//            return 0
//        }
//    
////    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
////        var rows = 0
////        if self.fetchedResultsController!.sections.count > 0 {
////            var sectionInfo = self.fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
////            rows = sectionInfo.numberOfObjects
////        }
////        return rows
////    }
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let sectionInfo = fetchedResultsController?.sections![section] as? NSFetchedResultsSectionInfo {
//            return sectionInfo.numberOfObjects
//        }
//        return 0
//    }
//    
//    //    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
//    //        let sectionInfo = self.fetchedResultsController!.sections[section] as NSFetchedResultsSectionInfo
//    //        return sectionInfo.name
//    //    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let sectionInfo = fetchedResultsController?.sections![section] as? NSFetchedResultsSectionInfo {
//            return sectionInfo.name
//        }
//        return "?"
//    }
//    
//    //    override func tableView(tableView: UITableView!, sectionForSectionIndexTitle title: String!, atIndex index: Int) -> Int {
//    //        return self.fetchedResultsController!.sectionForSectionIndexTitle(title, atIndex: index)
//    //    }
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        if let sectionIndex =  fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) {
//            return sectionIndex
//        }
//        return 0;
//    }
//    
//    //    override func sectionIndexTitlesForTableView(tableView: UITableView!) -> [AnyObject]! {
//    //        return self.fetchedResultsController!.sectionIndexTitles
//    //    }
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        if let sectionIndexTitles = fetchedResultsController?.sectionIndexTitles {
//            return sectionIndexTitles
//        }
//        return []
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

  /*

    //
    //  CoreDataTableViewController.m
    //
    //  Created for Stanford CS193p Winter 2013.
    //  Copyright 2013 Stanford University. All rights reserved.
    //
    
    #import "CoreDataTableViewController.h"
    
    @interface CoreDataTableViewController()
    @property (nonatomic) BOOL beganUpdates;
    @end
    
    @implementation CoreDataTableViewController
    
    #pragma mark - Properties
    
    @synthesize fetchedResultsController = _fetchedResultsController;
    @synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
    @synthesize debug = _debug;
    @synthesize beganUpdates = _beganUpdates;
    
    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
    return YES;
    }
    
    #pragma mark - Fetching
    
    - (void)performFetch
    {
    self.debug = YES;
    if (self.fetchedResultsController) {
    if (self.fetchedResultsController.fetchRequest.predicate) {
    if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
    } else {
    if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
    }
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
    if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
    }
    
    - (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
    {
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
    _fetchedResultsController = newfrc;
    newfrc.delegate = self;
    if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
    self.title = newfrc.fetchRequest.entity.name;
    }
    if (newfrc) {
    if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
    [self performFetch];
    } else {
    if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.tableView reloadData];
    }
    }
    }
    
    #pragma mark - UITableViewDataSource
    
    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
    return [[self.fetchedResultsController sections] count];
    }
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
    
    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    }
    
    - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
    {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
    }
    
    - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
    {
    return [self.fetchedResultsController sectionIndexTitles];
    }
    
    #pragma mark - NSFetchedResultsControllerDelegate
    
    - (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
    {
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
    [self.tableView beginUpdates];
    self.beganUpdates = YES;
    }
    }
    
    - (void)controller:(NSFetchedResultsController *)controller
    didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
    atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type
    {
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
    switch(type)
    {
    case NSFetchedResultsChangeInsert:
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    break;
    
    case NSFetchedResultsChangeDelete:
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    break;
    }
    }
    }
    
    
    - (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
    newIndexPath:(NSIndexPath *)newIndexPath
    {
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
    switch(type)
    {
    case NSFetchedResultsChangeInsert:
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    break;
    
    case NSFetchedResultsChangeDelete:
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    break;
    
    case NSFetchedResultsChangeUpdate:
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    break;
    
    case NSFetchedResultsChangeMove:
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    break;
    }
    }
    }
    
    - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
    {
    if (self.beganUpdates) [self.tableView endUpdates];
    }
    
    - (void)endSuspensionOfUpdatesDueToContextChanges
    {
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
    }
    
    - (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
    {
    if (suspend) {
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
    [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
    }
    
    @end

 */

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARKX: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
//
//    /*
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
//
//        // Configure the cell...
//
//        return cell
//    }
//    */
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARKX: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */

}
