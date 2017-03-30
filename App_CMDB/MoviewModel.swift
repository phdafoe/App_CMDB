//
//  MoviewModel.swift
//  App_CMDB
//
//  Created by Andres on 30/3/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation

class MovieModel{
    
    var id : String?
    var title : String?
    var order : Int?
    var summary : String?
    var image : String?
    var category : String?
    var director : String?
    
    init(pId : String?, pTitle : String?, pOrder : Int?, pSummary : String?, pImage : String?, pCategory : String?, pDirector : String?) {
        self.id = pId
        self.title = pTitle
        self.order = pOrder
        self.summary = pSummary
        self.image = pImage
        self.category = pCategory
        self.director = pDirector
    }
    
    
}
