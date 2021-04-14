//
//  CastCell.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit

class CastCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var castImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(cast:Cast,size:CGFloat) {
        self.widthConstraint.constant = size - 35
        self.heightContraint.constant = size - 35
        self.nameLbl.text = cast.name
        self.castImageView.setImageWith(urlString: cast.profile_path)
    }
    
}
