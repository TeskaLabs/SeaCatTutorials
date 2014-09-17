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









// Start listening on defined port, this keep running the application until hit Ctrl + C key combination.  
app.listen(app.get('port'), function(){
  console.log("Host is running and listening on http://localhost:" + app.get('port') + '; press Ctrl-C to terminate.');  
});