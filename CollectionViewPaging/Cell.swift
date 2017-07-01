//
//  File.swift
//  CollectionViewPaging
//
//  Created by Pablo Alcalde on 1/7/17.
//  Copyright © 2017 Cabify Rider v2. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    override func awakeFromNib() {
        image.image = UIImage.init(named: "vehicle.png")
    }
}
