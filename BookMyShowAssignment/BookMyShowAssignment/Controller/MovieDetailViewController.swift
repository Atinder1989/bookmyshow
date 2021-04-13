//
//  MovieDetailViewController.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var castCollectionView: UICollectionView!

    private var movie :Movie!
    private var movieDetailViewModel = MovieDetailViewModel()
    private var castList: [Cast] = [] {
        didSet{
            self.castCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSetting()
        self.addViewModelListeners()
        self.movieDetailViewModel.getMovieDetailData(movie: self.movie)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

//MARK:- Public Methods
extension MovieDetailViewController {
    func setMovie(movie :Movie) {
        self.movie = movie
    }
}
//MARK:- Private Methods
extension MovieDetailViewController {
    private func customSetting() {
        castCollectionView.register(CastCell.nib, forCellWithReuseIdentifier: CastCell.identifier)
    }
    
    private func addViewModelListeners() {
        self.movieDetailViewModel.dataClosure = {[weak self] in
            if let this = self {
                DispatchQueue.main.async {
                    this.updateScreenUI()
                }
            }
        }
    }
    
    private func updateScreenUI() {
        self.title = self.movie.title
        self.movieImageView.setImageWith(urlString: movie.poster_path)
        self.releaseDateLbl.text = "Release Date : \(self.movie.release_date)"
        self.ratingLbl.text = "\(self.movie.vote_average)"
        self.overviewTextView.text = self.movie.overview
        self.updateCompanyName()
        self.updateAuthorName()
        if let credit = self.movieDetailViewModel.creditResponse {
            self.castList = credit.castList
        }
//        let gradient:CAGradientLayer = CAGradientLayer()
//           gradient.frame.size = self.gradientView.frame.size
//           gradient.colors = [UIColor.black.cgColor,UIColor.black.withAlphaComponent(0).cgColor] //Or any colors
//        self.gradientView.layer.addSublayer(gradient)
        
    }
    
    private func updateCompanyName() {
        if let synopsis = self.movieDetailViewModel.synopsisResponse {
            var text = "Company: "
            for (index, element) in synopsis.productionCompanyList.enumerated() {
                if index < synopsis.productionCompanyList.count-1 {
                    text = "\(text)\(element.name),"
                } else {
                    text = "\(text)\(element.name)"
                }
            }
            self.companyLbl.text = text
        }
    }
    private func updateAuthorName() {
        if let review = self.movieDetailViewModel.reviewResponse {
            var text = "Author: "
            for (index, element) in review.reviewList.enumerated() {
                if index < review.reviewList.count-1 {
                    text = "\(text)\(element.author),"
                } else {
                    text = "\(text)\(element.author)"
                }
            }
            self.authorLbl.text = text
        }
    }
}


//MARK:- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.castCollectionView.frame.height)
        return CGSize.init(width: self.castCollectionView.frame.height, height: self.castCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.castList.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath) as! CastCell
        cell.setData(cast: self.castList[indexPath.row], size: self.castCollectionView.frame.height)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    
}
