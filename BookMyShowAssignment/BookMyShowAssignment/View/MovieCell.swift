//
//  MovieCell.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var bookButton: UIButton!

    @IBOutlet weak var posterImageViewWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utility.setView(view: cellBackgroundView, cornerRadius: 20, borderWidth: 1, color: .black)
        Utility.setView(view: posterImageView, cornerRadius: 15, borderWidth: 0, color: .clear)
        Utility.setView(view: bookButton, cornerRadius: 15, borderWidth: 0, color: .clear)
        self.posterImageViewWidth.constant = UIScreen.main.bounds.width/3
    }
    
    func setData(movie:Movie) {
        self.posterImageView.setImageWith(urlString: movie.poster_path)
        self.titleLbl.text = movie.title
        self.releaseDateLbl.text = "Release Date : \(movie.release_date)"
        self.ratingLbl.text = "\(movie.vote_average)"
        self.overViewLbl.text = movie.overview
    }

}
