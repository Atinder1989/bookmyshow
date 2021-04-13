//
//  ServiceHelper.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation

class ServiceHelper: NSObject {
    static var baseURL: ServiceEnvironment {
        get {
            return ServiceEnvironment.Development
        }
    }
}

//MARK: All Apis
extension ServiceHelper {
    static func moviesListUrl(page:Int) -> String {
        return baseURL.rawValue + "3/movie/now_playing?api_key=\(moviesDbApplicationKey)&page=\(page)"
    }
    
    static func synopsisUrl(movieId:Int) -> String {
        return baseURL.rawValue + "3/movie/\(movieId)?api_key=\(moviesDbApplicationKey)&language=en-US"
    }
    
    static func reviewsUrl(movieId:Int) -> String {
        return baseURL.rawValue + "3/movie/\(movieId)/reviews?api_key=\(moviesDbApplicationKey)&language=en-US&page=1"
    }
    
    static func creditUrl(movieId:Int) -> String {
        return baseURL.rawValue + "3/movie/\(movieId)/credits?api_key=\(moviesDbApplicationKey)&language=en-US"
    }
   
    static func similarMoviesUrl(movieId:Int) -> String {
        return baseURL.rawValue + "3/movie/\(movieId)/similar?api_key=\(moviesDbApplicationKey)&language=en-US&page=1"
    }
}





