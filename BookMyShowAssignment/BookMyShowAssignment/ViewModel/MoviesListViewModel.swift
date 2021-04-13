//
//  MoviesListViewModel.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation


class MoviesListViewModel:AppViewModel  {
    var dataClosure : (() -> Void)?
    var routeToMovieDetailClosure : ((_ movie:Movie) -> Void)?
    var movieListResponse: MovieListResponse? = nil {
        didSet{
            if let closure = self.dataClosure {
                closure()
            }
        }
    }
}

//MARK:- Public Methods
extension MoviesListViewModel {
    func getMoviesList(page:Int) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.moviesListUrl(page: page)
        ServiceManager.processDataFromServer(service: service, model: MovieListResponse.self) { (responseData, error) in
            if let _ = error {
                self.movieListResponse = nil
            } else {
                if let response = responseData {
                    self.movieListResponse = response
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
        default:break
        }
    }
    
}
