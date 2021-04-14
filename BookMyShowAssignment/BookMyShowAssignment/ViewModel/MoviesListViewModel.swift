//
//  MoviesListViewModel.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation
import UIKit


class MoviesListViewModel:NSObject  {
    private var pageIndex = 1
    private var movieListResponse: MovieListResponse? = nil {
        didSet{
            if let closure = self.dataClosure {
                closure()
            }
        }
    }
    
    var dataClosure : (() -> Void)?
    var routeToMovieDetailClosure : ((_ movie:Movie) -> Void)?
    var routeToSearchClosure : ((_ movielist :[Movie]) -> Void)?

}

//MARK:- Public Methods
extension MoviesListViewModel {
    func getMoviesList() {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.moviesListUrl(page: pageIndex)
        ServiceManager.processDataFromServer(service: service, model: MovieListResponse.self) { [weak self] (responseData, error) in
           
            if let this = self {
            if let _ = error {
                this.movieListResponse = nil
            } else {
                if let res = responseData {
                    if let gridResponse = this.movieListResponse {
                        var oldResponse = gridResponse
                        oldResponse.page = res.page
                        oldResponse.total_pages = res.total_pages
                        oldResponse.total_results = res.total_results
                        oldResponse.movielist.append(contentsOf: res.movielist)
                        this.movieListResponse = oldResponse
                    }else {
                        this.movieListResponse = res
                    }
                }
            }
            }
            
        }
    }
    
    func handleEvent(event:MovieListEvent) {
        switch event {
        case .bookMovie(movie: let movie):
            if let closure = self.routeToMovieDetailClosure{
                closure(movie)
            }
        case .search:
            if let response = self.movieListResponse, let closure = self.routeToSearchClosure{
                closure(response.movielist)
            }
        default:break
        }
    }
}

//MARK:- Private Methods
extension MoviesListViewModel {
    private func getNextPageMovieList(){
        if let response = self.movieListResponse {
            let newPage = response.page + 1
            if newPage <= response.total_pages {
                self.pageIndex = newPage
                self.getMoviesList()
            }
        }
    }
}


//MARK:- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension MoviesListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let response = self.movieListResponse {
            return response.movielist.count
        }
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell ,let response = self.movieListResponse{
                        movieCell.setData(movie: response.movielist[indexPath.row])
            return movieCell
            }
                
        return UICollectionViewCell()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let response = self.movieListResponse {
            self.handleEvent(event: .bookMovie(movie: response.movielist[indexPath.row]))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let response = self.movieListResponse {
            if indexPath.row == response.movielist.count - 1 {
                self.getNextPageMovieList()
            }
        }
    }

   
}
