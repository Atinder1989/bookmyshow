//
//  AppRouter.swift
//  BookMyShowAssignment
//
//  Created by Atinder on 13/04/21.
//

import Foundation
import UIKit

enum Route: String {
    case movieDetail
    case search
    case none
}

protocol Router {
   func route(
      to route: Route,
      from context: UIViewController,
      parameters: Any?
   )
}

class AppRouter: Router {   
    func route(to route: Route, from context: UIViewController, parameters: Any?) {
        switch route {
        case .movieDetail:
            if let params = parameters,let movie = params as? Movie {
                if let vc = self.getViewController(ofType: MovieDetailViewController.self) {
                    vc.setMovie(movie: movie)
                    context.navigationController?.pushViewController(vc, animated: true)
                }
            }
            break
        case .search:
            if let params = parameters,let movies = params as? [Movie] {
                if let vc = self.getViewController(ofType: SearchViewController.self) {
                    vc.setMovieList(movies: movies)
                    context.navigationController?.pushViewController(vc, animated: true)
                }
            }
            break
           default:
            break
        }
    }
    
    // MARK: - Get ViewController From Storyboard
    private func getViewController<T:UIViewController>(ofType viewController:T.Type) -> T?
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: type(of: T()))) as? T {
            return vc
        }
        return nil
    }
}
