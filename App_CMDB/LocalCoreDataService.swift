//
//  LocalCoreDataService.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import CoreData


class LocalCoreDataService {
    
    //invocamos a remote service
    let remoteMovieService = RemoteItunesMoviewService()
    
    
    //1
    func searchMovie(_ byTerm : String, remoteHandler : @escaping (_ model : [MovieModel]?) -> ()){
        
        //2
        remoteMovieService.searchMovies(byTerm) { (result) in
            if let moviesData = result{
                var modelMovies = [MovieModel]()
                for c_movie in moviesData{
                    
                    let obj = MovieModel(pId: c_movie["id"]!,
                                         pTitle: c_movie["title"]!,
                                         pOrder: nil,
                                         pSummary: c_movie["summary"]!,
                                         pImage: c_movie["image"]!,
                                         pCategory: c_movie["category"]!,
                                         pDirector: c_movie["director"]!)
                    modelMovies.append(obj)
                }
                remoteHandler(modelMovies)
            }else{
                print("Error mientras se llama al los servicios de iTunes")
                remoteHandler(nil)
            }
        }
    }
    
    //2
    func topMovie(_ localHandler : @escaping (_ model : [MovieModel]?) -> (), remoteHandler : @escaping (_ model : [MovieModel]?) -> ()){
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
