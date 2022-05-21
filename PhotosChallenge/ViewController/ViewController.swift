//
//  ViewController.swift
//  PhotosChallenge
//
//  Created by kholy on 18/05/2022.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!{
        didSet{
            self.moviesTableView.delegate = self
            self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        }
    }
    let appServerClient = AppServerClient()
    let movies = Movies()
    var photos = [Photo]()
    var isUpdating : Bool = false
    var page = 1
    var pages = 0

    let viewModel: PhotosTableViewViewModel = PhotosTableViewViewModel()
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.getPhotos()
    }
    
    func bindViewModel() {
        viewModel.photosCells.bind(to: self.moviesTableView.rx.items) { tableView, index, element in
            self.isUpdating = false
            switch element {
            case .normal(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
                cell.setData(photo: viewModel)
                return cell
            }
        }.disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.page = self.viewModel.movies.photos.page
        self.pages = self.viewModel.movies.photos.pages
        
        for cell in moviesTableView.visibleCells {
          if let row = moviesTableView.indexPath(for: cell)?.item {
            print("In Row \(row) In \(viewModel.photos.count)")
            if row > (photos.count - 5){
                if page < pages && !isUpdating{
                    self.isUpdating = true
                    viewModel.getPhotos(page+1)
                }
            }
          }
        }
    }
}
