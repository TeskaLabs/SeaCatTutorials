//
//  MovieDetailViewController.swift
//  RESTClientImprovement
//
//  Created by Radek Tomasek on 1/25/15.
//  Copyright (c) 2015 codeforios.com. All rights reserved.
//

import UIKit

protocol MovieDetailViewControllerDelegate {
    func movieDetailViewController(controller: MovieDetailViewController, didFinishAddingMovie movie: Movie)
    func movieDetailViewController(controller: MovieDetailViewController, didFinishEditingMovie movie: Movie)
}

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    
    var delegate: MovieDetailViewControllerDelegate? = nil
    var movieToEdit: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.becomeFirstResponder()
        title = "Add Movie"
        
        if let movie = movieToEdit {
            title = "Edit Movie"
            nameTextField.text = movie.name
            directorTextField.text = movie.director
            releaseYearTextField.text = String(movie.releaseYear)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getName() -> String {
        return nameTextField.text
    }
    
    func getDirector() -> String {
        return directorTextField.text
    }
    
    func getReleaseYear() -> Int {
        var input = releaseYearTextField.text.toInt()
        var returnValue: Int
        
        if input != nil {
            returnValue = input!
        }
        else {
            return 1900
        }
        
        return returnValue
    }

    @IBAction func saveItemAction(sender: AnyObject) {
        if delegate != nil {
            if let movie = movieToEdit {
                movie.name = getName()
                movie.director = getDirector()
                movie.releaseYear = getReleaseYear()
                
                delegate?.movieDetailViewController(self, didFinishEditingMovie: movie)
            }
            else {
                var name = getName()
                var director = getDirector()
                var releaseYear = getReleaseYear()
                
                var movie = Movie(name: name, director: director, releaseYear: releaseYear)
                
                delegate?.movieDetailViewController(self, didFinishAddingMovie: movie)
            }
        }
    }
}
