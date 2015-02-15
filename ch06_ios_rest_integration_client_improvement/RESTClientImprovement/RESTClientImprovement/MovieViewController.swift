//
//  ViewController.swift
//  RESTClientImprovement
//
//  Created by Radek Tomasek on 2/14/15.
//  Copyright (c) 2015 seacat.mobi. All rights reserved.
//

import UIKit
import AlamoFire
import SwiftyJSON

// Definition of MovieViewController. Implementation of methods from MovieDetailViewControllerDelegate.
class MovieViewController: UITableViewController, MovieDetailViewControllerDelegate {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var movies = [Movie]()
    // Initialization of the objects.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.movies = [Movie]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Read data from Endpoint.
        self.doGET()
    }
    
    // Calculate number of elements in array - number of rows in UITableView.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Function which help transform elements from array into cells.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let movie =  movies[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        label.text = movie.name
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    // Prepare for segue for both AddMovie and EditMovie. Passing information from one segue to another, in advance. Assigning delegates.
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
    
    // Overrriding function from superclass. Listen to swipe-in-cell action and help us to remove element both from client and Node.js host.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove movie from backend.
        doDELETE(forRowAtIndexPath: indexPath)
        
        movies.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    // This function helps us to make sure that no Row will be selected.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // Processing the adding method (method from protol). Adding data both to client array and Node.js Host.
    func movieDetailViewController(controller: MovieDetailViewController, didFinishAddingMovie movie: Movie) {
        let newRowIndex = movies.count
        movies.append(movie)
        
        // Add movie to backend.
        doPOST(movie, forRowIndex: newRowIndex)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        // Close the view controller (MovieDetailViewController).
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Processing the editing method (method from protol). Editing data both in client array and Node.js Host.
    func movieDetailViewController(controller: MovieDetailViewController, didFinishEditingMovie movie: Movie) {
        if let index = find(movies, movie) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            //Edit data in backend.
            doPUT(movie, forRowAtIndexPath: indexPath)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let label = cell.viewWithTag(1000) as UILabel
                label.text = movie.name
            }
        }
        
        // Close the view controller (MovieDetailViewController).
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Method doGET() basically process a GET request. Read defined ENDPOINT. If error, show an error message.
    func doGET() {
        Alamofire.request(.GET, "https://nodejshost.seacat/api/movies")
            .responseJSON { (request, response, json, error) in
                
                if let error = error {
                    self.showNetworkError()
                    self.addButton.enabled = false
                }
                else {
                    // JSON reading.
                    var json = JSON(json!)
                    
                    // JSON processing.
                    for (index:String, subJson: JSON) in json {
                        var name = subJson["name"].string!
                        var director = subJson["director"].string!
                        var releaseYear = subJson["release"].int!
                        
                        var movie = Movie(name: name, director: director, releaseYear: releaseYear)
                        self.movies.append(movie)
                    }
                    // Reloading of the context.
                    self.tableView.reloadData()
                }
        }
    }
    
    // Method doPOST() basically do a POST request. Send data to an ENDPOINT. Id will be actual rowIndex.
    func doPOST(movie: Movie, forRowIndex rowIndex: Int) {
        // Definition of parameters.
        let parameters: [String: AnyObject] = [
            "id": rowIndex,
            "name": movie.name,
            "director": movie.director,
            "release": movie.releaseYear
        ]
        
        Alamofire.request(.POST, "https://nodejshost.seacat/api/movies", parameters: parameters)
    }
    
    // Method doPUT() basically do a PUT request. Send updated data to defined ENDPOINT based on specified id element.
    func doPUT(movie: Movie, forRowAtIndexPath indexPath: NSIndexPath) {
        let id = indexPath.row
        // Definition of parameters.
        let parameters: [String: AnyObject] = [
            "id": id,
            "name": movie.name,
            "director": movie.director,
            "release": movie.releaseYear,
        ]
        
        Alamofire.request(.PUT, "https://nodejshost.seacat/api/movies/\(id)", parameters: parameters)
    }
    
    // Method doDELETE() basically do a DELETE request. Delete data in defined ENDPOINT based on specified id element.
    func doDELETE(forRowAtIndexPath indexPath: NSIndexPath) {
        let id = indexPath.row
        
        Alamofire.request(.DELETE, "https://nodejshost.seacat/api/movies/\(id)")
    }
    
    // Definition of alert in case of any error.
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Network Problem...",
            message: "There was an error reading from Host. Please try again.",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}