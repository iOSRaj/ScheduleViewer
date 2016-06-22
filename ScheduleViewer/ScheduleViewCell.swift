//
//  ScheduleViewCell.swift
//  ScheduleViewer
//
//  Created by Raj on 6/21/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {

    @IBOutlet weak var beginTaskDateTime: UILabel!
    @IBOutlet weak var endTaskDateTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
