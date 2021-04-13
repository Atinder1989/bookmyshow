//
//  MoviesListViewController.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import UIKit

enum MovieListEvent {
    case bookMovie(movie:Movie)
    case none
}

class MoviesListViewController: UIViewController {
    @IBOutlet weak var moviesListCollectionView: UICollectionView!
    
    private var router: AppRouter?
    private var initialPage = 1
    private var movieListViewModel = MoviesListViewModel()
    private var moviesList:[Movie] = [] {
        didSet{
            DispatchQueue.main.async {
                self.moviesListCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSetting()
        self.addViewModelListeners()
        self.movieListViewModel.getMoviesList(page: initialPage)
    }
    

}

//MARK:- Private Methods
extension MoviesListViewController {
    private func addViewModelListeners() {
        self.movieListViewModel.dataClosure = {[weak self] in
            if let this = self {
                if let response = this.movieListViewModel.movieListResponse {
                    this.moviesList = response.movielist
                }
            }
        }
        
        self.movieListViewModel.routeToMovieDetailClosure = {[weak self] movie in
            if let this = self {
                if let router = this.router {
                    router.route(to: .movieDetail, from: this, parameters: movie)
                }
            }
        }
        
    }
    
    private func customSetting() {
        self.title = "Movies List"
        self.router = AppRouter.init(viewModel: self.movieListViewModel)
        moviesListCollectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.identifier)
    }
}

//MARK:- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesList.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.setData(movie: self.moviesList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.movieListViewModel.handleEvent(event: .bookMovie(movie: self.moviesList[indexPath.row]))
    }

    
}
