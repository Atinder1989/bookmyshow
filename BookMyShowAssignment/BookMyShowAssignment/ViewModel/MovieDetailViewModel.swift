//
//  MovieDetailViewModel.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation

class MovieDetailViewModel:AppViewModel  {
    private let dispatchGroup = DispatchGroup()

    var dataClosure : (() -> Void)?
    var routeToMovieDetailClosure : ((_ movie:Movie) -> Void)?
    var synopsisResponse: SynopsisResponse? = nil
    var reviewResponse: ReviewResponse? = nil
    var creditResponse: CreditResponse? = nil
    var similarMovieResponse: SimilarMovieResponse? = nil
}


//MARK:- Public Methods
extension MovieDetailViewModel {
    func getMovieDetailData(movie:Movie) {
        dispatchGroup.enter()
        getSynopsisData(movie: movie)
        dispatchGroup.enter()
        getReviewData(movie: movie)
        dispatchGroup.enter()
        getCrediData(movie: movie)
        dispatchGroup.enter()
        getSimilarMoviesData(movie: movie)
        dispatchGroup.notify(queue: .main) {
            if let closure = self.dataClosure {
                closure()
            }
        }
    }
}

//MARK:- Private Methods
extension MovieDetailViewModel {
    private func getSynopsisData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.synopsisUrl(movieId: movie.id)
        ServiceManager.processDataFromServer(service: service, model: SynopsisResponse.self) { (responseData, error) in
            if let _ = error {
                self.synopsisResponse = nil
                self.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    self.synopsisResponse = response
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private func getReviewData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.reviewsUrl(movieId: movie.id)
        ServiceManager.processDataFromServer(service: service, model: ReviewResponse.self) { (responseData, error) in
            if let _ = error {
                self.reviewResponse = nil
                self.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    self.reviewResponse = response
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private func getCrediData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.creditUrl(movieId: movie.id)
        ServiceManager.processDataFromServer(service: service, model: CreditResponse.self) { (responseData, error) in
            if let _ = error {
                self.creditResponse = nil
                self.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    self.creditResponse = response
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private func getSimilarMoviesData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.similarMoviesUrl(movieId: movie.id)
        ServiceManager.processDataFromServer(service: service, model: SimilarMovieResponse.self) { (responseData, error) in
            if let _ = error {
                self.similarMovieResponse = nil
                self.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    self.similarMovieResponse = response
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
}
