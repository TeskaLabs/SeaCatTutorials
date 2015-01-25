//
//  ViewController.swift
//  RESTClientImprovement
//
//  Created by Radek Tomasek on 1/25/15.
//  Copyright (c) 2015 codeforios.com. All rights reserved.
//

import UIKit

class MovieViewController: UITableViewController, MovieDetailViewControllerDelegate {

    var movies: [Movie]
    
    required init(coder aDecoder: NSCoder) {
        movies = [Movie]()
        
        var movie1 = Movie(name: "Forrest Gump", director: "Robert Zemeckis", releaseYear: 1994)
        movies.append(movie1)
        
        var movie2 = Movie(name: "Donnie Darko", director: "Richard Kelly", releaseYear: 2001)
        movies.append(movie2)
        
        var movie3 = Movie(name: "Inception", director: "Christopher Nolan", releaseYear: 2010)
        movies.append(movie3)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "AddMovie" {
            let navigationController = segue.destinationViewController as UINavigationController
            
            let controller = navigationController.topViewController as MovieDetailViewController
            
            controller.delegate = self
        }
        else if segue.identifier == "EditMovie" {
            let navigationController = segue.destinationViewController as UINavigationController
            
            let controller = navigationController.topViewController as MovieDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                controller.movieToEdit = movies[indexPath.row]
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let movie =  movies[indexPath.row]
        
        let label = cell.viewWithTag(1000) as UILabel
        
        label.text = movie.name
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        movies.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func movieDetailViewController(controller: MovieDetailViewController, didFinishAddingMovie movie: Movie) {
        let newRowIndex = movies.count
        movies.append(movie)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func movieDetailViewController(controller: MovieDetailViewController, didFinishEditingMovie movie: Movie) {
        if let index = find(movies, movie) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let label = cell.viewWithTag(1000) as UILabel
                label.text = movie.name
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

