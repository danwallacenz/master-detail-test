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
        return report
    }
}

