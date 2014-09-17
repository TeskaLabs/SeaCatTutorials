// NodeRESTHost.js
// A simple REST host in Node.js with using Express.js framework.
//
// All data stored in memory, requests are handled in particular routes.
// 
// Created in 2014 by Radek Tomasek / SeaCat Ltd. 

// Include Express.js framework scripts.
var express = require('express');

// Initialize app by using Express framework.
var app = express();

// Set default port 1337 or custom if defined by user externally.
app.set('port', process.env.PORT || 1337);







// Use Express midleware to handle 404 and 500 error states.
app.use(function(request, response){
   // Set status 404 if none of above routes processed incoming request. 
   response.status(404); 
   // Generate the output
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