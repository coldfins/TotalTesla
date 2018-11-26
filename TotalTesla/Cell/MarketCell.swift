//
//  CommentHeaderView.swift
//  HeaderTableview
//
//  Created by Ved on 03/11/15.
//  Copyright © 2015 Ved. All rights reserved.
//

import UIKit

class MarketCell: UITableViewCell {

    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var switchMarket: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
