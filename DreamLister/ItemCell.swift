//
//  ItemCell.swift
//  DreamLister
//
//  Created by Aleksei Neronov on 15.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thub: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func configureCell(item: Item) {
        title.text = item.title
        price.text = "\(item.price)"
        details.text = item.details
    }
    
}
