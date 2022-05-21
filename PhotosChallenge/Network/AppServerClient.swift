//
//  AppServerClient.swift
//  PhotosChallenge
//
//  Created by kholy on 18/05/2022.
//

import Alamofire
import RxSwift
import PKHUD

// MARK: - AppServerClient
class AppServerClient {


    typealias GetFriendsResult = Movies
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
        
    func getPhotos(page : Int = 1) -> Observable<Movies> {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show(onView: getTopViewController()?.view ?? UIView())
        
        return Observable.create { observer -> Disposable in
            AF.request("https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=50&text=Color&page=\(page)&per_page=20&api_key=d17378e37e555ebef55ab86c4180e8dc")
                .validate()
                .responseDecodable(of: Movies.self) { response in
                    switch response.result {
                    case .success:
                        debugPrint("Response: \(response)")
                        do {
                            guard let data = response.data else {
                                observer.onNext(Movies())
                                PKHUD.sharedHUD.hide()
                                return
                            }
                            let movies = try JSONDecoder().decode(Movies.self, from: data)
                            //print(movies.stat)
                            observer.onNext(movies)
                            PKHUD.sharedHUD.hide()
                        } catch {
                            observer.onNext(Movies())
                            PKHUD.sharedHUD.hide()
                        }
                    case .failure(_):
                        observer.onNext(Movies())
                        PKHUD.sharedHUD.hide()
                    }
                }

            return Disposables.create()
        }
    }
    
    func getTopViewController() -> UIViewController! {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

}
