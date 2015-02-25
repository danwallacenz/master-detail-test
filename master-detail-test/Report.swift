//
//  Report.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 26/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import Foundation
import CoreData

class Report: NSManagedObject {

    @NSManaged var creationDate: NSDate
    @NSManaged var creationLatitude: NSNumber
    @NSManaged var creationLongitude: NSNumber
    @NSManaged var formData: FormData
    @NSManaged var locations: Locations
    @NSManaged var photoAlbum: PhotoAlbum

}
