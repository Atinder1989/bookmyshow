//
//  RecentlySearchCell.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 14/04/21.
//

import UIKit

class RecentlySearchCell: UICollectionViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utility.setView(view: cellBackgroundView, cornerRadius: 20, borderWidth: 1, color: .black)

    }
    func setData(movie:Movie) {
        self.posterImageView.setImageWith(urlString: movie.poster_path)
        self.titleLbl.text = movie.title
    }
    

}
