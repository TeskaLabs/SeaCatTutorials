//
//  Movie.swift
//  RESTClientImprovement
//
//  Created by Radek Tomasek on 2/14/15.
//  Copyright (c) 2015 seacat.mobi. All rights reserved.
//

import UIKit

// Definition of Movie class. 
// Attributes Name, Director and ReleaseYear will come from objects stored in memory in the Node.js webservice.
// We need NSObject to be the superclass of our Movie class. We will use some functions like 'find' and we need to conform the class Movie 'Equatable' protocol. NSObject helps us to accomplish this task.

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