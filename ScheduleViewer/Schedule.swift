//
//  Schedule.swift
//  Tasks
//
//  Created by Raj on 6/21/16.
//  Copyright © 2016 Raj. All rights reserved.

import UIKit

class Schedule: NSObject, NSCoding {
    // MARK: Properties

    var beginDate: String?
    var endDate: String?

    // MARK: Archiving Paths

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("tasks")

    // MARK: Types

    struct PropertyKey {
        static let beginKey = "begin"
        static let endkey = "end"
    }

    // MARK: Initialization

    init?(beginDate: String, endDate: String) {
        // Initialize stored properties.
        self.beginDate = beginDate
        self.endDate = endDate

        super.init()

        // Initialization should fail if there is no name or if the rating is negative.
        if endDate.isEmpty {
            return nil
        }
    }

    // MARK: NSCoding

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(beginDate, forKey: PropertyKey.beginKey)
        aCoder.encodeObject(endDate, forKey: PropertyKey.endkey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let beginDate = aDecoder.decodeObjectForKey(PropertyKey.beginKey) as! String
        let endDate = aDecoder.decodeObjectForKey(PropertyKey.endkey) as! String

        // Must call designated initializer.
        self.init(beginDate: beginDate, endDate: endDate)
    }

}