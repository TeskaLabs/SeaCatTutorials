//
//  ViewController.swift
//  RESTClient
//
//  Created by Radek Tomasek on 10/5/14.
//  Copyright (c) 2014 seatcat.mobi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let manager = AFHTTPRequestOperationManager()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var releaseTextField: UITextField!
    @IBOutlet weak var verbInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var responseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Manage Accesibility for UITextFields just after the initialization.
        manageAccessibilityForUITextFields(verbInSegmentedControl.selectedSegmentIndex)
        dataCleaningForUITextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func manageAccessibilityForUITextFields(verb: Int) {
        switch verb {
            // We are going to handle UITextFields based on GET (index 0).
        case 0:
            idTextField.enabled = true
            nameTextField.enabled = false
            directorTextField.enabled = false
            releaseTextField.enabled = false
            // We are going to handle UITextFields based on POST (index 1).
        case 1:
            idTextField.enabled = false
            nameTextField.enabled = true
            directorTextField.enabled = true
            releaseTextField.enabled = true
        case 2:
            // We are going to handle UITextFields based on PUT (index 2).
            idTextField.enabled = true
            nameTextField.enabled = true
            directorTextField.enabled = true
            releaseTextField.enabled = true
            // We are going to handle UITextFields based on DELETE (index 3).
        case 3:
            idTextField.enabled = true
            nameTextField.enabled = false
            directorTextField.enabled = false
            releaseTextField.enabled = false
            // Enabled all fields in Default.
        default:
            idTextField.enabled = true
            nameTextField.enabled = true
            directorTextField.enabled = true
            releaseTextField.enabled = true
        }
    }
    
    func dataCleaningForUITextFields() {
        // Clean all fields in every situation.
        
        idTextField.text = String()
        nameTextField.text = String()
        directorTextField.text = String()
        releaseTextField.text = String()
        responseTextField.text = String()
    }
    
    func populateTextFields(responseObject: AnyObject!) {
        let jsonResult = responseObject as Dictionary<String, AnyObject>
        nameTextField.text = String(jsonResult["name"] as AnyObject! as String)
        directorTextField.text = String(jsonResult["director"] as AnyObject! as String)
        releaseTextField.text = String(jsonResult["release"] as AnyObject! as Int)
    }
    
    func displaySuccessMessage(message: String) {
        self.responseTextField.textColor = UIColor.darkGrayColor()
        self.responseTextField.text = message
    }
    
    func displayErrorMessage(message: String) {
        self.responseTextField.textColor = UIColor.redColor()
        self.responseTextField.text = message
    }
    
    
    func getRequest() {
        var id: String = idTextField.text
        if countElements(id) == 0 {
            displayErrorMessage("ID element is empty")
        }
        else
        {
            manager.GET("https://nodejshost.seacat/api/movies/\(id)",
                parameters: nil,
                success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    let message = "Data received successfully!"
                    self.populateTextFields(responseObject)
                    self.displaySuccessMessage(message)
                },
                failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                    self.dataCleaningForUITextFields()
                    let message = error.localizedDescription
                    self.responseTextField.textColor = UIColor.redColor()
                    self.responseTextField.text = message
            })
        }
    }
    
    func postRequest() {
        var name = nameTextField.text
        var director = directorTextField.text
        var release = releaseTextField.text
        var parameters = ["name": name, "director": director, "release": release]
        
        manager.POST("https://nodejshost.seacat/api/movies",
            parameters: parameters,
            success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                let message = "Data successfully sent!"
                self.displaySuccessMessage(message)
            },
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                self.dataCleaningForUITextFields()
                let message = error.localizedDescription
                self.responseTextField.textColor = UIColor.redColor()
                self.responseTextField.text = message
        })
    }
    
    func putRequest() {
        var id = idTextField.text
        var name = nameTextField.text
        var director = directorTextField.text
        var release = releaseTextField.text
        var parameters = ["name": name, "director": director, "release": release]
        
        if countElements(id) == 0 {
            displayErrorMessage("ID element is empty")
        }
        else {
            manager.PUT("https://nodejshost.seacat/api/movies/\(id)",
                parameters: parameters,
                success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    let message = "Data successfully sent!"
                    self.displaySuccessMessage(message)
                },
                failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                    self.dataCleaningForUITextFields()
                    let message = error.localizedDescription
                    self.responseTextField.textColor = UIColor.redColor()
                    self.responseTextField.text = message
            })
        }
    }
    
    func deleteRequest() {
        var id = idTextField.text
        if countElements(id) == 0 {
            displayErrorMessage("ID element is empty")
        }
        else {
            manager.DELETE("https://nodejshost.seacat/api/movies/\(id)",
                parameters: nil,
                success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    let message = "Object successfully deleted!"
                    self.displaySuccessMessage(message)
                },
                failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                    self.dataCleaningForUITextFields()
                    let message = error.localizedDescription
                    self.responseTextField.textColor = UIColor.redColor()
                    self.responseTextField.text = message
            })
        }
    }
    
    
    @IBAction func selectVerbInSegmentedControl(sender: AnyObject) {
        manageAccessibilityForUITextFields(sender.selectedSegmentIndex)
        dataCleaningForUITextFields()
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        switch (verbInSegmentedControl.selectedSegmentIndex)
            {
        case 0:
            self.getRequest()
        case 1:
            self.postRequest()
        case 2:
            self.putRequest()
        case 3:
            self.deleteRequest()
        default:
            println("Undefined request")
        }
    }


}

