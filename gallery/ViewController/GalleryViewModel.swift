//
//  GalleryViewModel.swift
//  gallery
//
//  Created by Algis on 17/10/2020.
//

import Foundation

class GalleryViewModel {
    
    enum State: Equatable {
        case loading
        case finished
        case empty
    }
    
    private let galleryService: GalleryServiceProtocol
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatusClosure: ((State)->())?
    
    private var recipes: [Recipe] = [Recipe]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var state: State = .loading {
        didSet {
            self.updateLoadingStatusClosure?(state)
        }
    }
    
    var numberOfItems: Int {
        return recipes.count
    }
    
    init(galleryService: GalleryServiceProtocol) {
        self.galleryService = galleryService
    }
    
    func fetchData() {
        self.state = .loading
        galleryService.fetchImages { [weak self] (result: Result<[Recipe], APIServiceError>) in
            switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                    (recipes.count == 0) ? (self?.state = .empty) : (self?.state = .finished)
                case .failure(let error):
                    self?.state = .empty
                    print(error.localizedDescription)
            }
        }
    }
    
    func getData(at indexPath: IndexPath ) -> Recipe {
        return recipes[indexPath.row]
    }
}
