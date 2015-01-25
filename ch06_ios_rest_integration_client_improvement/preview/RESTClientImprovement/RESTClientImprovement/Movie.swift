//
//  Movie.swift
//  RESTClientImprovement
//
//  Created by Radek Tomasek on 1/25/15.
//  Copyright (c) 2015 codeforios.com. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var name: String
    var director: String
    var releaseYear: Int
    
    init(name: String, director: String, releaseYear: Int) {
        self.name = name
        self.director = director
        self.releaseYear = releaseYear
        
        super.init()
    }
   
}
