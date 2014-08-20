/*
A simple host in Node.js parsing a post request. 

Response is sent to standard output. 

Created in 2014 by Radek Tomasek / Seal Teaks Ltd.
*/

var http = require('http');

http.createServer(function (request, response) {
	// Check whether the method is POST
	if (req.method == 'POST') 
	{
		// Redirect the output to STDOUT.
		request.pipe(process.stdout);		
		// Prepare a header.  
		response.writeHead(200, {'Content-Type': 'text/json'});		
		// Write the response.
		request.pipe(response);		
	}
}).listen(1337);

console.log("Running the Node.js host");
