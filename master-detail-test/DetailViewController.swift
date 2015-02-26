//
//  DetailViewController.swift
//  master-detail-test
//
//  Created by Daniel Wallace on 25/02/15.
//  Copyright (c) 2015 nz.co.danielw. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var report: Report? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    private var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
    }
    
    func configureView() {
        // Update the user interface for the report.
        if let report: Report = self.report {
            if let label = self.detailDescriptionLabel {
                label.text = dateFormatter.stringFromDate(report.creationDate)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}