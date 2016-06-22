//
//  ViewController.swift
//  ScheduleViewer
//
//  Created by Raj on 6/21/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var schedules = [Schedule]()

    @IBOutlet weak var scheduleTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem()

        self.title = "Schedule(s)"

        // Load any saved schdeules, otherwise load sample data.
        if let savedSchedules = loadSchdeules() {
            schedules += savedSchedules
        }

    }

    override func setEditing(editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        self.scheduleTableView.setEditing(editing, animated: true)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ScheduleTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ScheduleViewCell

        schedules.sortInPlace { $0.beginDate!.localizedCaseInsensitiveCompare($1.beginDate!) == NSComparisonResult.OrderedAscending }
        // Fetches the appropriate schedule for the data source layout.
        let schedule = schedules[indexPath.row]

        cell.beginTaskDateTime.text = schedule.beginDate
        cell.endTaskDateTime.text = schedule.endDate

        return cell
    }

    // Support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            schedules.removeAtIndex(indexPath.row)
            saveSchdeules()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let scheduleDetailViewController = segue.destinationViewController as! AddSchdeuleViewController

            // Get the cell that generated this segue.
            if let selectedCell = sender as? ScheduleViewCell {
                let indexPath = self.scheduleTableView.indexPathForCell(selectedCell)!
                let selectedSchedule = schedules[indexPath.row]
                scheduleDetailViewController.schedule = selectedSchedule
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new schdeule.")
        }
    }

    @IBAction func unwindToSchdeuleList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddSchdeuleViewController, schdeule = sourceViewController.schedule {
            if let selectedIndexPath = self.scheduleTableView.indexPathForSelectedRow {
                // Update an existing schedule.
                schedules[selectedIndexPath.row] = schdeule
                self.scheduleTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new schdeule.
                let newIndexPath = NSIndexPath(forRow: schedules.count, inSection: 0)
                schedules.append(schdeule)
                self.scheduleTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the schdeules.
            saveSchdeules()
            self.scheduleTableView.reloadData()
        }
    }

    // MARK: NSCoding
    func saveSchdeules() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(schedules, toFile: Schedule.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save schedule...")
        }
    }

    func loadSchdeules() -> [Schedule]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Schedule.ArchiveURL.path!) as? [Schedule]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

