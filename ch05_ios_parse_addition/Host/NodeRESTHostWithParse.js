// NodeRESTHostWithParse.js
// A simple REST host in Node.js with using Express.js framework and Backend-As-A-Service (BAAS) Parse.com
//
// All data stored in Parse.com, requests are handled in particular routes.
// 
// Created in 2015 by Radek Tomasek / SeaCat Ltd. 

// Include external modules - Express.js, BodyParser and Parse.com.
var Express = require('express');
var BodyParser = require('body-parser');
var Parse = require('parse').Parse;

var APP_ID = "YOUR_APP_ID";
var JAVASCRIPT_KEY = "YOUR_JAVASCRIPT_KEY";

// Connect with Parse.com Infrastructure.
var parseApp = Parse.initialize(APP_ID, JAVASCRIPT_KEY);

// Initialize app by using Express framework.
var app = Express();

// Use Body Parser (Helps to process incoming requests).
app.use(BodyParser.urlencoded({extended: true}));
app.use(BodyParser.json());

// Set default port 1337 or custom if defined by user externally.
app.set('port', process.env.PORT || 1337);

// Configure variables related to Parse.com for working with our Movies schema
var Movies = Parse.Object.extend("Movies");
var query = new Parse.Query(Movies);

// Simple function which checks whether a parameter is null or not.
function isNull(parameter) {
  return parameter === null ? true : false;  
}

// Seeding Initial Data. Populates only once, then the code is skipped. 
query.find({
  success: function(movies) {
    if (movies.length) {
      return;
    }
    // Initial array with some movies.
    var movies = [
        {mid: 1, name: "Forrest Gump", director: "Robert Zemeckis", release: 1994},
        {mid: 2, name: "Donnie Darko", director: "Richard Kelly", release: 2001},
        {mid: 3, name: "Inception", director: "Christopher Nolan", release: 2010}
    ];    
    for (var i = 0; i < movies.length; i++) {
        // Create a new object which represents Parse.com object.
        var movie = new Movies();        
        // Set values from array.
        movie.set("mid", movies[i].mid);
        movie.set("name", movies[i].name);
        movie.set("director", movies[i].director);
        movie.set("release", movies[i].release);        
        // Save object to backend (Parse.com).
        movie.save(null, {
          success: function(movie) {
            // Execute any logic that should take place after the object is saved.
            console.log('New object created with objectId: ' + movie.id);
          },
          error: function(movie, error) {
            // Execute any logic that should take place if the save fails.
            // error is a Parse.Error with an error code and message.
            console.log('Failed to create new object, with error code: ' + error.message);
          }
        });
    }
  },
  error: function(object, error) {
    // The object was not retrieved successfully.
    // error is a Parse.Error with an error code and message.
    console.log(error);
  }
});

// GET - list of all records.
app.get('/api/movies', function(request, response, next){
  var localQuery = new Parse.Query(Movies);
  // Find all records stored in Movies Object.  
  localQuery.find({
    success: function(results) {
      // List of all records from Parse.com backend and return as a JSON.
      response.json(results.map(function(movie){
        return {
         id: movie.attributes.mid,
         name: movie.attributes.name,
         director: movie.attributes.director,
         release: movie.attributes.release
        }
      }));
    },
    // In case of any error, forward request to error handler.
    error: function(error) {
      console.log("Error: " + error.code + " " + error.message);
      next();
    }
  });
});

// GET - list of a record with particular id. If not found, forward the request to 404 - not found. 
app.get('/api/movies/:id', function(request, response, next){  
  var localQuery = new Parse.Query(Movies);
  // Read ID and parse its integer value from URL request.
  var id = parseInt(request.params.id);  
  // Find the particular object.
  localQuery.equalTo("mid", id);
  localQuery.find({
    success: function(movie) {
      // In case of empty result, forward to 404.
      if (!movie.length) {
        next();
      }
      else {      
        // return as a JSON with the result. Result is returned in form of array with 1 element.
        response.json({
          id: movie[0].attributes.mid,
          name: movie[0].attributes.name,
          director: movie[0].attributes.director,
          release: movie[0].attributes.release
        });
      }
    },
    // In case of any error, forward request to error handler.
    error: function(error) {
      console.log("Error: " + error.code + " " + error.message);
      next();
    }
  });
});


// POST - create a new element.
app.post('/api/movies', function(request, response, next){
  var localQuery = new Parse.Query(Movies);
  // Complete request body.
  var requestBody = request.body;
  // Get number of elements stored in Backend, to be able to increase the custom ID.
  localQuery.find({
    success: function(results) {
      // Read number of elements.
      var numberOfElements = results.length
      // Prepare new data.
      var newMovie = {
        mid: ++numberOfElements,
        name: requestBody.name,
        director: requestBody.director,
        release: requestBody.release
      };
      // Create a new object.
      var movie = new Movies();  
      // Set values from array.
      movie.set("mid", newMovie.mid);
      movie.set("name", newMovie.name);
      movie.set("director", newMovie.director);
      movie.set("release", newMovie.release);  
      // Save object to backend (Parse.com).
      movie.save(null, {
        success: function(movie) {
          // Execute any logic that should take place after the object is saved.
          console.log('New object created with objectId: ' + movie.id);
          // Prepare status code 200 and close the response.
          response.status(200).end();
        },
        error: function(movie, error) {
          // Execute any logic that should take place if the save fails.
          // error is a Parse.Error with an error code and message.
          console.log('Failed to create new object, with error code: ' + error.message);
          next();
        }
      });
    },
    error: function(error) {
      // In case of an issue forward the response to ERROR handles. 
      console.log("Error: " + error.code + " " + error.message);
      next();
    }
  });
});



// PUT - update existing element.
app.put('/api/movies/:id', function(request, response, next){
  var localQuery = new Parse.Query(Movies);
  // Complete request body.
  var requestBody = request.body;
  // Read ID from user's request and parse its integer value.
  var id = parseInt(request.params.id);
  // Continue only when id is an actual integer number.
  if (!isNaN(id)) {
    localQuery.equalTo("mid", id);
    localQuery.find({
      success: function(results) {
        // In case of empty result, forward to 404.
        if (!results.length) {
          next();
        }
        else {      
          // Prepare data update. If any of existing element is null in JSON, read the older values. 
          var movieUpdate = {
            mid: id,
            name: isNull(requestBody.name) ? results[0].get("name") : requestBody.name,
            director: isNull(requestBody.director) ? results[0].get("director") : requestBody.director,
            release: isNull(requestBody.release) ? results[0].get("release") : requestBody.release
          };
          // Update object.
          results[0].save(null, {
            success: function(movie) {
              // Now let's update it with some new data. 
              movie.set("name", movieUpdate["name"]);
              movie.set("director", movieUpdate["director"]);
              movie.set("release", movieUpdate["release"]);
              movie.save();              
              // Element successfuly updated. Prepare status code 200 and close the response.
              response.status(200).end();
            },
            error: function(error) {
              console.log("Error: " + error.code + " " + error.message);
              next();
            }
          });
        }
      },
      // In case of any error, forward request to error handler.
      error: function(error) {
        console.log("Error: " + error.code + " " + error.message);
        next();
      }
    });
  } else {
    // In case of an issue forward the response to ERROR handles. 
    console.log("You specified invalid number!");
    next();
  }
});  

// DELETE - remove particular record from array.
app.delete('/api/movies/:id', function(request, response, next){
  var localQuery = new Parse.Query(Movies);
  // Read ID and parse its integer value from URL request.
  var id = parseInt(request.params.id);  
  // Continue only when id is an actual integer number.
  if (!isNaN(id)) {
    // Find the particular object.
    localQuery.equalTo("mid", id);
    // Delete record based on movie id.
    localQuery.find({
      success: function(results) {
        // In case of empty result, forward to 404.
        if (!results.length) {
          next();
        }
        else {
          // Actual record removing.
          results[0].destroy({});
          console.log("Deleted 1 row from Parse.com!");
          // Prepare status code 200 and close the response.
          response.status(200).end();
        }
      },
      // In case of an issue forward the response to ERROR handles. 
      error: function(error) {
        console.log("Error: " + error.code + " " + error.message);
        next();
      }
    });
  } else {
    // In case of an issue with input integer number forward the response to ERROR handles. 
    console.log("You specified invalid number!");
    next();
  }
}); 


// Use Express midleware to handle 404 and 500 error states.
app.use(function(request, response){
   // Set status 404 if none of above routes processed incoming request. 
   response.status(404); 
   // Generate the output.
   response.send('404 - not found');
});

// 500 error handling. This will be handled in case of any internal issue on the host side.
app.use(function(err, request, response){
  // Set response type to application/json.
  response.type('application/json');
  // Set response status to 500 (error code for internal server error).
  response.status(500);
  // Generate the output - an Internal server error message. 
  response.send('500 - internal server error');
});

// Start listening on defined port, this keep running the application until hit Ctrl + C key combination.  
app.listen(app.get('port'), function(){
  console.log("Host is running and listening on http://localhost:" + app.get('port') + '; press Ctrl-C to terminate.');  
});

