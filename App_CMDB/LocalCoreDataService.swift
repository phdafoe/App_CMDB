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
    let stack = CoreDataStack.shared
    
    
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
        
        //1
        localHandler(queryTopMovies())
        //2
        remoteMovieService.getTopMovies { (result) in
            if let moviesData = result{
                //proceso de sync
                self.markAllMoviesAnUnsync()
                var order = 1
                
                for c_movieDiccionario in moviesData{
                    
                    if let movieData = self.getMovieById(c_movieDiccionario["id"]!, favorite: false){
                        
                        // update
                        self.updateMovie(c_movieDiccionario, movie: movieData, order: order)
                        
                    }else{
                        // insert
                        self.insertMovie(c_movieDiccionario, order: order)
                    }
                    //sumamos uno a nuestro orden
                    order += 1
                }
                
                //puede que no hayan peliculas OJO
                // Borrar los no sincrinizados
                self.removeAllNotFavoriteMovies()
                
                remoteHandler(self.queryTopMovies())
                
            }else{
                print("Error mientras se llama al los servicios de iTunes")
                remoteHandler(nil)
            }
        }
        
    }
    
    
    //3
    func queryTopMovies() -> [MovieModel]?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        
        do{
            let fetchMovies = try context.fetch(request)
            var movie = [MovieModel]()
            for c_manageMovie in fetchMovies{
                movie.append(c_manageMovie.mappedObject())
            }
            return movie
            
        }catch{
            print("Error mientras se obtienen las peliculas desde CoreData")
            return nil
        }
    }
    
    
    //4
    func markAllMoviesAnUnsync(){
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        
        do{
            let fetchMovies = try context.fetch(request)
            
            for c_manageMovie in fetchMovies{
                c_manageMovie.sync = false
            }
            
            try context.save()
            
        }catch{
            print("Error mientras se actualizan las peliculas desde CoreData")
        }
    }
    
    
    //5
    func getMovieById(_ id : String, favorite : Bool) -> MovieManager?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "id = \(id) and favorito = \(favorite)")
        request.predicate = customPredicate
        
        
        do{
            let fetchMovies = try context.fetch(request)
            
            if fetchMovies.count > 0{
                
                return fetchMovies.last
            }else{
                return nil
            }
            
            
        }catch{
            print("Error mientras se obtienen peliculas desde CoreData")
            return nil
        }
        
        
    }
    
    
    //6
    func insertMovie(_ movieDiccionario : [String : String], order : Int){
        
        
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario, movie: movie, order: order)

        
    }
    
    //7
    func updateMovie(_ movieDiccionario : [String : String], movie : MovieManager, order : Int){
        
        let context = stack.persistentContainer.viewContext
        
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        
        do{
           try context.save()
            
        }catch{
            print("Error mientras se actualiza el CoreData")
        }
        
    }
    
    //8
    func removeAllNotFavoriteMovies(){
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        //una vez que se hace el insert y el update debemos saber quw todos pasan a sync true
        do{
            let fetchMovies = try context.fetch(request)
            
            for c_managerMovie in fetchMovies{
                
                if !c_managerMovie.sync{
                    context.delete(c_managerMovie)
                }
            }
            try context.save()
            
        }catch{
            print("Error mientras borrando CoreData")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
