//
//  FormData.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 26/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import Foundation
import CoreData

class FormData: NSManagedObject {

    @NSManaged var color: String
    @NSManaged var notes: String
    @NSManaged var reportName: String
    @NSManaged var report: Report

}
