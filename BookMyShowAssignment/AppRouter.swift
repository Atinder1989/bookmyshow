//
//  AppRouter.swift
//  BookMyShowAssignment
//
//  Created by Savleen on 13/04/21.
//

import Foundation
import UIKit

enum Route: String {
    case movieDetail
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
    private var viewModel: AppViewModel
    init(viewModel: AppViewModel) {
       self.viewModel = viewModel
    }
    
    func route(to route: Route, from context: UIViewController, parameters: Any?) {
        switch route {
        case .movieDetail:
            if let params = parameters {
                if let movie = params as? Movie {
                    let vc = self.getViewController(ofType: MovieDetailViewController.self)
                    vc.setMovie(movie: movie)
                    context.navigationController?.pushViewController(vc, animated: true)
                }
            }
            break
           default:
            break
        }
    }
    
    
    // MARK: - Get ViewController From Storyboard
    private func getViewController<T:UIViewController>(ofType viewController:T.Type) -> T
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: type(of: T()))) as! T
    }
}
