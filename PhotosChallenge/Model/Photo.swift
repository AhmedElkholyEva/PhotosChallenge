//
//  Photo.swift
//  PhotosChallenge
//
//  Created by kholy on 18/05/2022.
//

struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    let farm: Int
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    init(cachedObj : SavedPhoto){
        self.id = cachedObj.id ?? ""
        self.owner = cachedObj.owner ?? ""
        self.secret = cachedObj.secret ?? ""
        self.server = cachedObj.server ?? ""
        self.title = cachedObj.title ?? ""
        self.farm = Int(cachedObj.farm)
        self.ispublic = Int(cachedObj.ispublic)
        self.isfriend = Int(cachedObj.isfriend)
        self.isfamily = Int(cachedObj.isfamily)
    }
}

struct Photos: Decodable{
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
    
    init() {
        self.page = 0
        self.pages = 0
        self.perpage = 0
        self.total = 0
        self.photo = [Photo]()
    }
}

struct Movies: Decodable{
    let photos: Photos
    let stat: String
    
    init(){
        self.stat = "0"
        self.photos = Photos()
    }
}
