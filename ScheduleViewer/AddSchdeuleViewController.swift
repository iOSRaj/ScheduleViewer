//
//  AddSchdeuleViewController.swift
//  ScheduleViewer
//
//  Created by Raj on 6/21/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

class AddSchdeuleViewController: UIViewController {

    var schedule: Schedule?

    @IBOutlet weak var beginTaskDate: UILabel!
    @IBOutlet weak var endTaskDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Schedule"
        self.datePicker.minimumDate = NSDate()

        if let schedule = schedule {
            self.beginTaskDate.text = schedule.beginDate
            self.endTaskDate.text = schedule.endDate
        } else {
            self.beginTaskDate.text = "Begin Task : " + NSDateFormatter.dateFormat().stringFromDate(NSDate())
            addWeekToDate()
        }
    }

    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let beginTask = beginTaskDate.text
            let endTask = endTaskDate.text ?? ""

            // Set the schedule to be passed to TableViewController after the unwind segue.
            schedule = Schedule(beginDate: beginTask!, endDate: endTask)
        }
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController

        if isPresentingInAddMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }

    @IBAction func datePickerChanged(sender: AnyObject) {
        self.beginTaskDate.text = NSDateFormatter.dateFormat().stringFromDate(datePicker.date)
        addWeekToDate()
    }

    func addWeekToDate() {
        let addWeekToDate = NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfMonth, value: 1, toDate: datePicker.date, options: [])
        self.endTaskDate.text = "End Task : " + NSDateFormatter.dateFormat().stringFromDate(addWeekToDate!)
    }

}

extension NSDateFormatter {

    public class func dateFormat() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter
    }

}