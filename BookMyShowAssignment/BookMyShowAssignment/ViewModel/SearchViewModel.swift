//
//  SearchViewModel.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 14/04/21.
//

import Foundation
import UIKit

class SearchViewModel:NSObject  {
    private var searchList:[Movie] = [] {
        didSet{
            DispatchQueue.main.async { [weak self] in
                if let this = self, let closure = this.refreshListClosure {
                    closure()
                }
            }
        }
    }
    private var isRecentlySearch = false
    private var recentlySearchMovieList = [Movie]()
    private var databaseManager = DatabaseManager()
    
    var moviesList = [Movie]()
    var routeToMovieDetailClosure : ((_ movie:Movie) -> Void)?
    var refreshListClosure : (() -> Void)?

}

//MARK:- Public Methods
extension SearchViewModel {
    func checkRecentSearchCacheMovies() {
        if databaseManager.getCacheMovies().count > 0 {
            isRecentlySearch = true
            if let closure = self.refreshListClosure {
                self.recentlySearchMovieList = databaseManager.getCacheMovies()
                closure()
            }
        } else {
            isRecentlySearch = false
        }
    }
    
    func searchMovie(searchText:String) {
        if searchText.count > 0 {
            self.isRecentlySearch = false
            searchList = self.updateSearchResults(searchText: searchText)
        } else {
            checkRecentSearchCacheMovies()
        }
    }
}


//MARK:- Private Methods
extension SearchViewModel {
     private func updateSearchResults(searchText:String) -> [Movie] {
        var searchList = [Movie]()
        if searchText.count == 1 {
            _ = self.moviesList.map { movie in
                let array = movie.title.components(separatedBy: " ")
            _ = array.map{ splitText in
                if splitText.character(at: 0)?.lowercased() == searchText.lowercased() {
                    let elementList = searchList.filter{$0.id == movie.id}
                    if elementList.count == 0 {
                        searchList.append(movie)
                    }
                }
            }
                
        }
            return searchList
        }
        
        let searchTextSplitArray = searchText.components(separatedBy: " ")
        _ = moviesList.map { movie in
            _ = searchTextSplitArray.map{splitText in
                if movie.title.lowercased().range(of:splitText.lowercased()) != nil {
                    let elementList = searchList.filter{$0.id == movie.id}
                    if elementList.count == 0 {
                        searchList.append(movie)
                    }
                }
            }
        }
        
        return searchList
    }
    
    private func handleEvent(event:MovieListEvent) {
        switch event {
        case .bookMovie(movie: let movie):
            if let closure = self.routeToMovieDetailClosure{
                closure(movie)
                DatabaseManager().saveMovieInfo(movie: movie)

            }
        default:break
        }
    }
    
}


//MARK:- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension SearchViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isRecentlySearch {
            if indexPath.row == 0 {
                return CGSize.init(width: UIScreen.main.bounds.size.width, height: 20)
            }
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: 80)
        }
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRecentlySearch {
            return self.recentlySearchMovieList.count + 1
        }
        return self.searchList.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isRecentlySearch {
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlySearchHeaderCell.identifier, for: indexPath) as? RecentlySearchHeaderCell {
                    return cell
                }
            }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlySearchCell.identifier, for: indexPath) as? RecentlySearchCell {
                cell.setData(movie: self.recentlySearchMovieList[indexPath.row-1])
                return cell
            }
        }
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
                movieCell.setData(movie: self.searchList[indexPath.row])
            return movieCell
        }
                
        return UICollectionViewCell()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isRecentlySearch {
            self.handleEvent(event: .bookMovie(movie: self.recentlySearchMovieList[indexPath.row-1]))
        } else {
            self.handleEvent(event: .bookMovie(movie: self.searchList[indexPath.row]))
        }
    }
    
    
    
}
