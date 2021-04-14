//
//  SearchViewController.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 14/04/21.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var moviesListCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!

    private var searchViewModel = SearchViewModel()
    private var router = AppRouter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSettings()
        self.addViewModelListeners()
        self.searchViewModel.checkRecentSearchCacheMovies()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

}

//MARK:- Public Methods
extension SearchViewController {
    func setMovieList(movies :[Movie]) {
        self.searchViewModel.moviesList = movies
    }
}

//MARK:- Private Methods
extension SearchViewController {
    private func customSettings() {
        self.title = "Search"
        moviesListCollectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.identifier)
        moviesListCollectionView.register(RecentlySearchCell.nib, forCellWithReuseIdentifier: RecentlySearchCell.identifier)
        moviesListCollectionView.register(RecentlySearchHeaderCell.nib, forCellWithReuseIdentifier: RecentlySearchHeaderCell.identifier)
        moviesListCollectionView.dataSource = self.searchViewModel
        moviesListCollectionView.delegate = self.searchViewModel
    }
    
    private func addViewModelListeners() {
        self.searchViewModel.routeToMovieDetailClosure = {[weak self] movie in
            if let this = self {
                this.router.route(to: .movieDetail, from: this, parameters: movie)
            }
        }
        
        self.searchViewModel.refreshListClosure = {[weak self]  in
            DispatchQueue.main.async {
                if let this = self {
                    this.moviesListCollectionView.reloadData()
                }
            }
        }
        
     }
}

extension SearchViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        self.searchViewModel.searchMovie(searchText: resultString)
        return true
    }
}
