//
//  ProductTblCell.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit

class ProductTblCell: UITableViewCell {

    @IBOutlet weak var imgVwProductImage: UIImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgVwCountryFlag: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
