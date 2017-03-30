//
//  MovieManager+Maping.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation

extension MovieManager{
    
    //lo que conseguimos con esto es que sobre cualquier objeto manage podra ejecutar el retorno de un objeto del tipo MovieModel
    func mappedObject() -> MovieModel {
        return MovieModel(pId: self.id!,
                          pTitle: self.title!,
                          pOrder: Int(self.order),
                          pSummary: self.summary!,
                          pImage: self.image!,
                          pCategory: self.category!,
                          pDirector: self.director!)
    }
}
