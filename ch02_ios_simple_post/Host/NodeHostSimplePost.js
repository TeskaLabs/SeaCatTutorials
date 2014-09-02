/*
A simple host in Node.js parsing a post request. 

Response is sent to standard output. 

Created in 2014 by Radek Tomasek / Seal Teaks Ltd.
*/

var http = require('http');
var querystring = require('querystring');

http.createServer(function (request, response) {
	// Check whether the method = 'POST'.
	if (request.method === 'POST') 
	{
		// Variable postData is for storing incoming chunks of POST data.
		var postData = "";
		
		// Set UTF-8 encoding for request.
		request.setEncoding("utf-8");
		
		// Processing of POST chunks. Active method until all chunks have been collected.
		request.addListener('data', function(data){
			// Collect POST data.
			postData += data;
			// Limit the size of buffer -> 1e6 = 1 * 10 ^ 6 = ~ 1 MB.
			if (postData.length > 1e6)
			{
				// Kill the connection if too much of POST data.
				request.connection.destroy();
			}
		});
		
		// Once all POST data is collected, following method is triggered.
		request.addListener('end', function(){
			// Check if really received POST (based on the content type).
			if (request.headers['content-type'] === 'application/x-www-form-urlencoded')
			{
				// Prepare the header.
				response.writeHead(200, {'Content-Type': 'text/json'});		
				// Read post data.
				var post = querystring.parse(postData);
				// Write the result to console. 
				console.log(post);
				// End the request.
				response.end();
			}
		});
	}
	// Handle the request if method is something else than POST.
	else 
	{
		// Write default header.
		response.writeHead(200, "Default request", {'Content-Type': 'text/plain'});
		// End of the Request.
		response.end();
	}
}).listen(1337);

console.log("Running the Node.js host");
