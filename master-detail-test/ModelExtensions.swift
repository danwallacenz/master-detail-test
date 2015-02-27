//
//  ModelExtensions.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 26/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import Foundation
import CoreData

extension Report {
    
    class func createInManagedObjectContext(context: NSManagedObjectContext) -> Report {
        let report = NSEntityDescription.insertNewObjectForEntityForName("Report", inManagedObjectContext: context) as Report
        report.creationDate = NSDate()
        
        report.formData = FormData.createInManagedObjectContext(context, color: "Red", report: report)
        report.locations = Locations.createInManagedObjectContext(context, color: "Yellow", report: report)
        report.photoAlbum = PhotoAlbum.createInManagedObjectContext(context, color: "Orange", report: report)
        return report
    }
    
    var sectionIdentifier: String  {
        get {
            let calendar = NSCalendar.currentCalendar()
            let dateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self.creationDate)
            let tmp = "\((dateComponents.year * 10000) + (dateComponents.month * 100) + dateComponents.day)"
            return tmp
        }
    }
    
}

extension Locations {
    class func createInManagedObjectContext(context: NSManagedObjectContext, color: String, report: Report) -> Locations {
        let locations = NSEntityDescription.insertNewObjectForEntityForName("Locations", inManagedObjectContext: context) as Locations
        locations.color = color
        locations.report = report
        return locations
    }
}

extension FormData {
    class func createInManagedObjectContext(context: NSManagedObjectContext, color: String, report: Report) -> FormData {
        let formData = NSEntityDescription.insertNewObjectForEntityForName("FormData", inManagedObjectContext: context) as FormData
        formData.color = color
        formData.report = report
        return formData
    }
}

extension PhotoAlbum {
    class func createInManagedObjectContext(context: NSManagedObjectContext, color: String, report: Report) -> PhotoAlbum {
        let photoAlbum = NSEntityDescription.insertNewObjectForEntityForName("PhotoAlbum", inManagedObjectContext: context) as PhotoAlbum
        photoAlbum.color = color
        photoAlbum.report = report
        return photoAlbum
    }
}
