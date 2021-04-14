//
//  MovieDetailViewModel.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation
import UIKit

class MovieDetailViewModel:NSObject  {
    private let dispatchGroup = DispatchGroup()
    var movie :Movie!
    var dataClosure : (() -> Void)?
    var routeToMovieDetailClosure : ((_ movie:Movie) -> Void)?
    var synopsisResponse: SynopsisResponse? = nil
    var reviewResponse: ReviewResponse? = nil
    var creditResponse: CreditResponse? = nil
    var similarMovieResponse: SimilarMovieResponse? = nil
}


//MARK:- Public Methods
extension MovieDetailViewModel {
    func getMovieDetailData() {
        dispatchGroup.enter()
        getSynopsisData(movie: movie)
        dispatchGroup.enter()
        getReviewData(movie: movie)
        dispatchGroup.enter()
        getCreditData(movie: movie)
        dispatchGroup.enter()
        getSimilarMoviesData(movie: movie)
        dispatchGroup.notify(queue: .main) { [weak self] in
            if let this = self {
            if let closure = this.dataClosure {
                closure()
            }
            }
        }
    }
}

//MARK:- Private Methods
extension MovieDetailViewModel {
    private func getSynopsisData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.synopsisUrl(movieId: self.movie.id)
        ServiceManager.processDataFromServer(service: service, model: SynopsisResponse.self) { [weak self] (responseData, error) in
            if let this = self {
            if let _ = error {
                this.synopsisResponse = nil
                this.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    this.synopsisResponse = response
                    this.dispatchGroup.leave()
                }
            }
            }
        }
    }
    
    private func getReviewData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.reviewsUrl(movieId: self.movie.id)
        ServiceManager.processDataFromServer(service: service, model: ReviewResponse.self) {[weak self] (responseData, error) in
            if let this = self {

            if let _ = error {
                this.reviewResponse = nil
                this.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    this.reviewResponse = response
                    this.dispatchGroup.leave()
                }
            }
            }
        }
    }
    
    private func getCreditData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.creditUrl(movieId: self.movie.id)
        ServiceManager.processDataFromServer(service: service, model: CreditResponse.self) { [weak self] (responseData, error) in
            if let this = self {

            if let _ = error {
                this.creditResponse = nil
                this.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    this.creditResponse = response
                    this.dispatchGroup.leave()
                }
            }
            }
        }
    }
    
    private func getSimilarMoviesData(movie:Movie) {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.similarMoviesUrl(movieId: self.movie.id)
        ServiceManager.processDataFromServer(service: service, model: SimilarMovieResponse.self) { [weak self] (responseData, error) in
            if let this = self {
            if let _ = error {
                this.similarMovieResponse = nil
                this.dispatchGroup.leave()
            } else {
                if let response = responseData {
                    this.similarMovieResponse = response
                    this.dispatchGroup.leave()
                }
            }
            }
        }
    }
    
}


//MARK:- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension MovieDetailViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let credit = self.creditResponse {
            return credit.castList.count
        }
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath) as? CastCell ,let response = self.creditResponse{
            cell.setData(cast: response.castList[indexPath.row], size: collectionView.frame.height)
            return cell
            }
                
        return UICollectionViewCell()
        
    }
   
}
