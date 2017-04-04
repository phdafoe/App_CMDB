//
//  RemoteItunesMoviewService.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RemoteItunesMoviewService{
    
    //metodo para buscar peliculas y otro para el Top con callback
    func getTopMovies(complitionHandler : @escaping (_ arrayDiccionario : [[String : String]]?) -> ()){
        
        let urlData = URL(string: "https://itunes.apple.com/es/rss/topmovies/limit=99/json")!
        
        Alamofire.request(urlData, method: .get).validate().responseJSON { (responseData) in
            switch responseData.result{
            case .success:
                if let valorData = responseData.result.value{
                    
                    let json = JSON(valorData)
                    var resultData = [[String : String]]()
                    
                    let entries = json["feed"]["entry"].arrayValue
                    //print(entries)
                    for c_entry in entries{
                        
                        var movieDiccioanrio = [String : String]()
                        movieDiccioanrio["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                        movieDiccioanrio["title"] = c_entry["im:name"]["label"].stringValue
                        movieDiccioanrio["summary"] = c_entry["summary"]["label"].stringValue
                        movieDiccioanrio["image"] = c_entry["im:image"][0]["label"].stringValue.replacingOccurrences(of: "60x60", with: "500x500")
                        movieDiccioanrio["category"] = c_entry["category"]["attributes"]["label"].stringValue
                        movieDiccioanrio["director"] = c_entry["im:artist"]["label"].stringValue
                        
                        resultData.append(movieDiccioanrio)
                    }
                    //aqui metemos el Callback
                    complitionHandler(resultData)
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                complitionHandler(nil)
            }
        }
    }
    
    
    func searchMovies(_ byTerm : String, complitionHandler : @escaping (_ arrayDiccionario : [[String : String]]?) -> ()){
        
        let urlData = URL(string: "https://itunes.apple.com/search")!
        
        Alamofire.request(urlData, method: .get,
                          parameters: ["media" : "movie", "attribute" : "movieTerm", "term" : byTerm],
                          encoding: URLEncoding.default,
                          headers: nil).validate().responseJSON { (resultData) in
                            
            switch resultData.result{
                
            case .success:
                //var resultmovie = [[String : String]]()
                if let valorData = resultData.result.value{
                    let json = JSON(valorData)
                    var resultmovie = [[String : String]]()
                    let entries = json["results"].arrayValue
                    for c_entry in entries{
                        var movieDiccionario = [String : String]()
                        movieDiccionario["id"] = c_entry["trackId"].stringValue
                        movieDiccionario["title"] = c_entry["trackName"].stringValue
                        movieDiccionario["summary"] = c_entry["longDescription"].stringValue
                        movieDiccionario["image"] = c_entry["artworkUrl100"].stringValue.replacingOccurrences(of: "100x100", with: "500x500")
                        movieDiccionario["category"] = c_entry["primaryGenreName"].stringValue
                        movieDiccionario["director"] = c_entry["artistName"].stringValue
                        resultmovie.append(movieDiccionario)
                    }
                    complitionHandler(resultmovie)
                }
                
                //complitionHandler(resultmovie)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                complitionHandler(nil)
            }
        
        }
    }
    
    
    
    
    
    
    
    
    
    
}
