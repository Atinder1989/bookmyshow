//
//  MovieDetailViewController.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var castCollectionView: UICollectionView!

    private var movieDetailViewModel = MovieDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSetting()
        self.addViewModelListeners()
        self.movieDetailViewModel.getMovieDetailData()
    }
    
}

//MARK:- Public Methods
extension MovieDetailViewController {
    func setMovie(movie :Movie) {
        self.movieDetailViewModel.movie = movie
    }
}
//MARK:- Private Methods
extension MovieDetailViewController {
    private func customSetting() {
        castCollectionView.register(CastCell.nib, forCellWithReuseIdentifier: CastCell.identifier)
        castCollectionView.dataSource = self.movieDetailViewModel
        castCollectionView.delegate = self.movieDetailViewModel
    }
    
    private func addViewModelListeners() {
        self.movieDetailViewModel.dataClosure = {[weak self] in
            if let this = self {
                DispatchQueue.main.async {
                    this.updateScreen()
                }
            }
        }
    }
    
    private func updateScreen() {
        self.title = self.movieDetailViewModel.movie.title
        self.movieImageView.setImageWith(urlString: self.movieDetailViewModel.movie.poster_path)
        self.releaseDateLbl.text = "Release Date : \(self.movieDetailViewModel.movie.release_date)"
        self.ratingLbl.text = "\(self.movieDetailViewModel.movie.vote_average)"
        self.overviewTextView.text = self.movieDetailViewModel.movie.overview
        self.castCollectionView.reloadData()
//        let gradient:CAGradientLayer = CAGradientLayer()
//           gradient.frame.size = self.gradientView.frame.size
//           gradient.colors = [UIColor.black.cgColor,UIColor.black.withAlphaComponent(0).cgColor] //Or any colors
//        self.gradientView.layer.addSublayer(gradient)
        
    }
    
    
}


