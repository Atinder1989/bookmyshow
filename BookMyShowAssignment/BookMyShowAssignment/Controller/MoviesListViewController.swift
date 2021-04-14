//
//  MoviesListViewController.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import UIKit

enum MovieListEvent {
    case bookMovie(movie:Movie)
    case search
    case none
}

class MoviesListViewController: UIViewController {
    @IBOutlet weak var moviesListCollectionView: UICollectionView!
    private var router = AppRouter()
    private var movieListViewModel = MoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSetting()
        self.addViewModelListeners()
        self.movieListViewModel.getMoviesList()
    }
    

}

//MARK:- Private Methods
extension MoviesListViewController {
    private func addViewModelListeners() {
        self.movieListViewModel.dataClosure = {[weak self] in
            if let this = self {
                    DispatchQueue.main.async {
                        this.moviesListCollectionView.reloadData()
                    }
            }
        }
        
        self.movieListViewModel.routeToMovieDetailClosure = {[weak self] movie in
            if let this = self {
                this.router.route(to: .movieDetail, from: this, parameters: movie)
            }
        }
        
        self.movieListViewModel.routeToSearchClosure = {[weak self] movielist in
            if let this = self {
                this.router.route(to: .search, from: this, parameters: movielist)
            }
        }
        
    }
    
    private func customSetting() {
        self.title = "Movies"
        moviesListCollectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.identifier)
        moviesListCollectionView.dataSource = self.movieListViewModel
        moviesListCollectionView.delegate = self.movieListViewModel
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTap))
    }
    
    @objc private func searchTap(){
        self.movieListViewModel.handleEvent(event: .search)
    }
}

