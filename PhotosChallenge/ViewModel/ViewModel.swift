//
//  ViewModel.swift
//  PhotosChallenge
//
//  Created by kholy on 21/05/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import CoreData

enum PhotoTableViewCellType {
    case normal(cellViewModel: Photo)
}

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

class PhotosTableViewViewModel {
    var photosCells: Observable<[PhotoTableViewCellType]> {
        return cells.asObservable()
    }
    
    let appServerClient: AppServerClient
    let disposeBag = DisposeBag()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let cells = BehaviorRelay<[PhotoTableViewCellType]>(value: [])
    var movies = Movies()
    var photos = [Photo]()
    var cachedPhotos = [SavedPhoto]()


    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }

    func getPhotos(_ page : Int = 1) {
        if Connectivity.isConnectedToInternet {
            if page > self.movies.photos.page{
                appServerClient.getPhotos(page: page).subscribe(
                    onNext: { [weak self] movies in
                        self?.photos.append(contentsOf: movies.photos.photo)
                        self?.movies = movies
                        self?.cells.accept(self?.photos.compactMap{ PhotoTableViewCellType.normal(cellViewModel: $0)} ?? [PhotoTableViewCellType]())
                        self?.delete(entityName: "SavedPhoto")
                        for photo in movies.photos.photo{
                            let obj = SavedPhoto(context: self!.context)
                            obj.id = photo.id
                            obj.owner = photo.owner
                            obj.secret = photo.secret
                            obj.server = photo.server
                            obj.isfamily = Int16(photo.isfamily)
                            obj.isfriend = Int16(photo.isfriend)
                            obj.ispublic = Int16(photo.ispublic)
                            obj.farm = Int16(photo.farm)
                            obj.title = photo.title
                            self?.cachedPhotos.append(obj)
                        }
                        self?.saveData()
                    })
                .disposed(by: disposeBag)
            }
         } else {
            loadPhotos()
         }
    }
    
    private func loadPhotos(with request: NSFetchRequest<SavedPhoto> = SavedPhoto.fetchRequest()) {
            do {
                cachedPhotos = try context.fetch(request)
            } catch {
                print("Error fetching data from context: \(error)")
            }
        print("cachedPhotos Count : \(cachedPhotos.count)")
            if self.cachedPhotos.count > 0{
                self.photos = [Photo]()
                for cachedObj in self.cachedPhotos{
                    let curPhoto = Photo(cachedObj: cachedObj)
                    self.photos.append(curPhoto)
                }
            }
        self.cells.accept(self.photos.compactMap{ PhotoTableViewCellType.normal(cellViewModel: $0)} )
    }
}
