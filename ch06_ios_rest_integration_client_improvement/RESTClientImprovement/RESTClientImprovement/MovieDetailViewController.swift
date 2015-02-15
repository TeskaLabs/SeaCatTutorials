import UIKit

protocol MovieDetailViewControllerDelegate {
    func movieDetailViewController(controller: MovieDetailViewController, didFinishAddingMovie movie: Movie)
    func movieDetailViewController(controller: MovieDetailViewController, didFinishEditingMovie movie: Movie)
}

// Definition of MovieDetailViewController class.
class MovieDetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var directorTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    
    // Variable for delegate, nil at the beginning.
    var delegate: MovieDetailViewControllerDelegate? = nil
    // A check whether the ViewController is going to handle form for new data or existing ones.
    var movieToEdit: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.becomeFirstResponder()
        // Change the default title to "Add movie"
        title = "Add Movie"
        
        // Load data to textFields if we want to edit data.
        if let movie = movieToEdit {
            title = "Edit Movie"
            nameTextField.text = movie.name
            directorTextField.text = movie.director
            releaseYearTextField.text = String(movie.releaseYear)
        }
    }
    
    // Read value of name textField.
    func getName() -> String {
        return nameTextField.text
    }
    
    // Read value of director textField.
    func getDirector() -> String {
        return directorTextField.text
    }
    
    // Read value of releaseYear textfield. If nil, then assign value 1900.
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
    
    // Make an action, distinguish between adding new data or editing existing ones. Using delegate to complete particular actions.
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